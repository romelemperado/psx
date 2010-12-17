using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using eZ430ChronosNet;
using System.Threading;
using System.IO;



namespace CalorieLogger
{
    public partial class CRL : Form
    {
        #region Data Members
        Chronos _chronos;
        DataParser _dataParser;
        //uint _chronosId;

        #endregion Data Members

        #region Methods

        public CRL()
        {
            InitializeComponent();

        }

        private void CRL_Load(object sender, EventArgs e)
        {
            //Window start: Add initialize here.
            _chronos = new Chronos();
            status.Clear();
            status.AppendText("Loading...");
            savedir.Clear();
            savedir.AppendText("*.csv");
            status.Clear();
            status.AppendText("PRESS SYNC from the watch when prompted.");
           

            //Button Init
            this.read.Enabled = false;
            this.erase.Enabled = false;
            this.download.Enabled = false;

        }

        private void sync_Click(object sender, EventArgs e)
        {

            
            byte[] data = new byte[19];
            DateTime dateTimeVar = DateTime.Now;
            
            
            try
            {
                _chronos.OpenComPort(_chronos.GetComPortName());//_chronos.GetComPortName() for ID purposes.

                this.sync.Enabled = false;
                this.read.Enabled = true;
                this.erase.Enabled = true;
                this.download.Enabled = true;
                status.Clear();
                _chronos.StartSimpliciTI();
                status.AppendText("RF Access Point opened. Start SYNC mode from watch now.");

                //Auto-set watch at SYNC----------------------------------------------------//
                data[0] = Constants.SYNC_AP_CMD_SET_WATCH;
                data[1] = (byte)(0x80 + (byte)dateTimeVar.Hour);
                data[2] = (byte)dateTimeVar.Minute;
                data[3] = (byte)dateTimeVar.Second;
                data[4] = (byte)((uint)dateTimeVar.Year >> 8);
                data[5] = (byte)((uint)dateTimeVar.Year & 0x00FF);
                data[6] = (byte)dateTimeVar.Month;
                data[7] = (byte)dateTimeVar.Day;
                data[8] = 0;
                data[9] = 0;
                data[10] = 0;
                data[11] = 0xC8;
                data[12] = 1;
                data[13] = 0xF4;
                data[14] = Constants.DATALOG_MODE_ACCELERATION + Constants.DATALOG_MODE_ALTITUDE +
                    Constants.DATALOG_MODE_TEMPERATURE;
                data[15] = 2; //2 seconds interval
                data[16] = 0;
                data[17] = 0;
                data[18] = 0;
                //------------------------------------------------------------------------//
            }
            catch
            {
                status.Clear();
                status.AppendText("USB RFAP device not found.");
                //Remind to plug USB
                return;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //Download Buttion
            int z;
            string savedr;
            savedr = save.FileName;//savedir.Text;//Template C:\Documents and Settings\User\Desktop\logfile.csv

            //Add download locations
            StreamWriter sw = new StreamWriter(@savedr, false);
            for (z = 0; z < _dataParser.GetDataCount(); z++)
            {
                sw.Write(_dataParser.dataTimestamp[z].ToString() + "," +
                    _dataParser.dataTemp[z].ToString() + "," +
                    _dataParser.dataAltitude[z].ToString() + "," +
                    _dataParser.dataAccX[z].ToString() + "," +
                    _dataParser.dataAccY[z].ToString() + "," +
                    _dataParser.dataAccZ[z].ToString() +
                    sw.NewLine
                    );
            }

        }

        //        #endregion Methods

        private void exit_Click(object sender, EventArgs e)
        {        
            byte[] data = new byte[19];
            int i;

            data[0] = Constants.SYNC_AP_CMD_EXIT;
            for (i = 1; i <= 18; i++) { data[i] = 0; }
            if (_chronos.SendSyncCommand(data))
            {
                status.Clear();
                status.AppendText("Closing in 1 sec...");
                Thread.Sleep(1000);
            }
            _chronos.StopSimpiliTI();//hahaha, wrong spelling. But still, thanks for the codes. :P
            _chronos.CloseComPort();
            Application.Exit();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //Read Button
            byte[] data = new byte[19];
            SyncStatus syncStatus;
            int packetCount = 0, maxPacket = 0, noofattmpt = 300, i; //, z;

            _dataParser = new DataParser();
            _dataParser.resetDataParser();

            //chronosGetId();
            //_chronos.GetID(out _chronosId);//from getID
            _chronos.ReadSyncBuffer(out data);//from getID
            chronosGetStatus();

            maxPacket = (_dataParser.bytesReady / 16 + 1);

            status.Clear();
            //status.AppendText("size: " + string.Format("{0:X2} ", _dataParser.bytesReady) + "bytes");
            status.AppendText("size: " + _dataParser.bytesReady + " bytes");
            if (_dataParser.bytesReady >= 1)
            {
                for (packetCount = 0; packetCount < maxPacket; packetCount++)
                {
                    data[0] = Constants.SYNC_AP_CMD_GET_MEMORY_BLOCKS_MODE_1;
                    for (i = 1; i <= 18; i++)
                        data[i] = 0;
                    data[1] = (byte)(packetCount >> 8);
                    data[2] = (byte)(packetCount & 0xFF);
                    data[3] = (byte)(packetCount >> 8);
                    data[4] = (byte)(packetCount & 0xFF);

                    _chronos.SendSyncCommand(data);

                    for (i = 1; i < noofattmpt; i++)
                    {
                        _chronos.GetSyncBufferStatus(out syncStatus);
                        if (syncStatus == SyncStatus.SYNC_USB_DATA_READY)
                        {
                            _chronos.ReadSyncBuffer(out data);
                            _dataParser.ParseData(data);
                            break;
                        }
                    }
                    if (i == noofattmpt) packetCount--; //try again  (more robust but might become infinite loop here)

                }
                status.Clear();
                status.AppendText("Ready for download.");
            }
            else
            {
                this.sync.Enabled = true;
                this.read.Enabled = false;
                this.erase.Enabled = false;
                this.download.Enabled = false;
                status.Clear();
                status.AppendText("No data ready for download. RF Access Point closed.");
                _chronos.StopSimpiliTI();

            }

            //Read button notes: Data parsing is used for temporary computer storage of gathered data.
            //Given that data were erased from the watch, data are available for download after READ and before EXIT.
        }
        
        private void button3_Click(object sender, EventArgs e)
        {
            //Erase Button
            byte[] data = new byte[19];
            int i;

            data[0] = Constants.SYNC_AP_CMD_ERASE_MEMORY;
            for (i = 1; i <= 18; i++) data[1] = 0;
            
            if (_chronos.SendSyncCommand(data))
            {
                status.Clear();
                status.AppendText("Flash Memory cleared.");
            }
            //
            Thread.Sleep(500);
            this.sync.Enabled = true;
            this.read.Enabled = false;
            this.erase.Enabled = false;
            this.download.Enabled = true;
            status.Clear();
            status.AppendText("RF Access Point closed.");
            
            _chronos.StopSimpiliTI();//hahaha, wrong spelling. But still, thanks for the codes. :P
            _chronos.CloseComPort();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            //Browse Button

            save.InitialDirectory = "C:"; //change "Leet" to your <computer_username>
            save.FileName = "*.csv";
            save.Filter = "Calorie Reader File (*.csv)|*.csv";

            if(save.ShowDialog() != DialogResult.Cancel)
            {
                savedir.Text = save.FileName;
            }
        }

       /* private void chronosGetId()
        {
            byte[] data = new byte[19];
            _chronos.GetID(out _chronosId);
            Thread.Sleep(500);
            _chronos.ReadSyncBuffer(out data);
            foreach (byte b in data)
            {
                status.Clear();
                status.AppendText(string.Format("{0:X2} ", b));
            }
            
        }*/

        private void chronosGetStatus()
        {
            byte[] data = new byte[19];
            SyncStatus syncStatus;
            int i, noofattmpt = 300;

            data[0] = Constants.SYNC_AP_CMD_GET_STATUS;
            for (i = 1; i <= 18; i++)
                data[i] = 0;
            if (_chronos.SendSyncCommand(data))
            //    status.AppendText("Sent SYNC_AP_CMD_GET_STATUS" + System.Environment.NewLine);

            for (i = 1; i < noofattmpt; i++)
            {
                _chronos.GetSyncBufferStatus(out syncStatus);
                if (syncStatus == SyncStatus.SYNC_USB_DATA_READY)
                {
                    _chronos.ReadSyncBuffer(out data);
                    /*foreach (byte b in data)
                    {
                        status.AppendText(string.Format("{0:X2} ", b));
                    }*/
                    
                    _dataParser.ParseStatus(data);
                    if (_dataParser.isStatusParserEnded())
                    {
                        /*status.AppendText("DataLog mode = " + _dataParser.datalogMode.ToString() +
                            System.Environment.NewLine);
                        status.AppendText("bytes Len = " + _dataParser.bytesReady.ToString() +
                            System.Environment.NewLine);
                        status.AppendText("interval = " + _dataParser.dataSecInterval.ToString() + " seconds." +
                            System.Environment.NewLine);
                        status.AppendText(_dataParser.day.ToString() + "/" + _dataParser.month.ToString() + "/" +
                            _dataParser.year.ToString() + "   " + _dataParser.hour.ToString() + ":" +
                            _dataParser.min.ToString() + ":" + _dataParser.sec.ToString() +
                            System.Environment.NewLine);
                        status.AppendText("   Temp = " + _dataParser.dataTemp[0].ToString() +
                            "   Alt = " + _dataParser.dataAltitude[0].ToString() +
                            "   x = " + _dataParser.dataAccX[0].ToString() +
                            "   y = " + _dataParser.dataAccY[0].ToString() +
                            "   z = " + _dataParser.dataAccZ[0].ToString() +
                            System.Environment.NewLine);
                        break;*/
                    }
                    break;
                }
            }
        }



        #endregion Methods
    }
}  


