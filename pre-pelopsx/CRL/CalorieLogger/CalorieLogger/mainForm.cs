/********************************************************************************
 *                                                                              *
 * Project: Chronoswatch Downloader                                             *
 * A software to download data logged using TI ez430-chronos watch              *
 * Requirement: ez430chronos.net and ZedGraph                                   *
 *                                                                              *
 * COPYRIGHT AND PERMISSION NOTICE                                              *
 *                                                                              *
 * Copyright (c) 2010-11 Rudi Voon (ruditronics.wordpress.com)                  *
 *                                                                              *
 * All rights reserved.                                                         *
 *                                                                              *
 * Permission to use, copy, modify, and distribute this software for any        *
 * purpose with or without fee is hereby granted, provided that the above       *
 * copyright notice and this permission notice appear in all copies.            *
 *                                                                              *
 * THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS     *
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD-PARTY RIGHTS.  *
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,  *
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR        *
 * OTHERWISE, ARISING FROM, OUT OF OR INCONNECTION WITH THE SOFTWARE OR THE     *
 * USE OR OTHER DEALINGS IN THE SOFTWARE.                                       *
 *                                                                              *
 * Except as contained in this notice, the name of a copyright holder shall     *
 * not be used in advertising or otherwise to promote the sale, use or other    *
 * dealings in this Software without prior written permission of the copyright  *
 * holder.                                                                      *
 *                                                                              *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell     *
 * copies of this Software, and permit persons to whom the Software is          *
 * furnished to do so, under these terms.                                       *
 *                                                                              *
 ********************************************************************************/
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
using ZedGraph;

namespace Chronoswatch_Downloader
{
    public partial class mainForm : Form
    {
        #region Data Members
        Chronos _chronos;
        DataParser _dataParser;
        uint _chronosId;
        PointPairList _list_AccX;
        PointPairList _list_AccY;
        PointPairList _list_AccZ;
        PointPairList _list_Temp;
        PointPairList _list_Alt;
        #endregion Data Members

        #region Methods

        public mainForm()
        {
            InitializeComponent();
        }
        private void mainForm_Load(object sender, EventArgs e)
        {
            
            _chronos = new Chronos();
            try
            {
                _chronos.OpenComPort(_chronos.GetComPortName());
            }
            catch
            {
                MessageBox.Show("Error cannot open port. Please check USB is connected");
                return;
            }
            
            if (_chronos.GetID(out _chronosId))
            {
                textBox1.AppendText(string.Concat("Chronos ID = ", _chronosId.ToString()) + System.Environment.NewLine);
            }
            _chronos.StartSimpliciTI();
            _list_AccX = new PointPairList();
            _list_AccY = new PointPairList();
            _list_AccZ = new PointPairList();
            _list_Temp = new PointPairList();
            _list_Alt = new PointPairList(); 
        }
        private void mainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            try
            {
                chronosExit();
                _chronos.StopSimpiliTI();
                _chronos.CloseComPort();
            }
            catch
            {
                MessageBox.Show("Error, port is already closed");
                return;
            }
        }
        private void btnDownload_Click(object sender, EventArgs e)
        {
            double x_axis;
            GraphPane paneAcc = zGraph_Acc.GraphPane;
            GraphPane paneTemp = zGraph_Temp.GraphPane;
            GraphPane paneAlt = zGraph_Alt.GraphPane;

            byte[] data = new byte[19];
            SyncStatus syncStatus;
            int i;
            int noOfAttempt = 300;
            int z;
            int packetCount = 0;
            int maxPacket = 0;

            panelButtons.Enabled = false;
            _dataParser = new DataParser();
            _dataParser.resetDataParser();

            chronosGetId();
            chronosGetStatus();

            maxPacket = (_dataParser.bytesReady / 16 + 1);

            textBox1.AppendText("bytesReady " + string.Format("{0:X2} ", _dataParser.bytesReady) +
                    System.Environment.NewLine);
            textBox1.AppendText("maxPacket  " + maxPacket.ToString() +
                    System.Environment.NewLine);
            textBox1.AppendText("Start Downloading  " + System.Environment.NewLine);
            progressBarDL.Maximum = maxPacket;
            progressBarDL.Value = 0;

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

                for (i = 1; i < noOfAttempt; i++)
                {
                    _chronos.GetSyncBufferStatus(out syncStatus);
                    if (syncStatus == SyncStatus.SYNC_USB_DATA_READY)
                    {
                        _chronos.ReadSyncBuffer(out data);
                        _dataParser.ParseData(data);

                        progressBarDL.Value++;
                        break;
                    }
                }
                if (i == noOfAttempt) packetCount--; //try again  (more robust but might become infinite loop here)
            }

            textBox1.AppendText("DataLog mode = " + _dataParser.datalogMode.ToString() +
                System.Environment.NewLine);
            textBox1.AppendText("interval = " + _dataParser.dataSecInterval.ToString() + " seconds." +
                System.Environment.NewLine);
            textBox1.AppendText(_dataParser.day.ToString() + "/" + _dataParser.month.ToString() + "/" +
                _dataParser.year.ToString() + "   " + _dataParser.hour.ToString() + ":" +
                _dataParser.min.ToString() + ":" + _dataParser.sec.ToString() +
                System.Environment.NewLine);
            for (z = 0; z < _dataParser.GetDataCount(); z++)
            {
                textBox1.AppendText(z.ToString() +
                    "   datetime  " + _dataParser.dataTimestamp[z].ToString() +
                    "   Temp = " + _dataParser.dataTemp[z].ToString() +
                    "   Alt = " + _dataParser.dataAltitude[z].ToString() +
                    "   x = " + _dataParser.dataAccX[z].ToString() +
                    "   y = " + _dataParser.dataAccY[z].ToString() +
                    "   z = " + _dataParser.dataAccZ[z].ToString() +
                    System.Environment.NewLine);

                x_axis = new XDate(_dataParser.dataTimestamp[z]);
                _list_AccX.Add(x_axis, _dataParser.dataAccX[z]);
                _list_AccY.Add(x_axis, _dataParser.dataAccY[z]);
                _list_AccZ.Add(x_axis, _dataParser.dataAccZ[z]);
                _list_Temp.Add(x_axis, _dataParser.dataTemp[z] / 10);
                _list_Alt.Add(x_axis, _dataParser.dataAltitude[z]);
            }
            paneAcc.AddCurve("X",
                        _list_AccX, Color.Red, SymbolType.Circle);
            paneAcc.AddCurve("Y",
                        _list_AccY, Color.Blue, SymbolType.Circle);
            paneAcc.AddCurve("Z",
                        _list_AccZ, Color.Green, SymbolType.Circle);
            paneTemp.AddCurve("Temp", _list_Temp, Color.Green, SymbolType.Circle);
            paneAlt.AddCurve("Alt", _list_Alt, Color.Green, SymbolType.Circle);
            paneAcc.XAxis.Type = AxisType.Date;
            paneTemp.XAxis.Type = AxisType.Date;
            paneAlt.XAxis.Type = AxisType.Date;
            paneAcc.XAxis.Title.Text = "Datetime";
            paneTemp.XAxis.Title.Text = "Datetime";
            paneAlt.XAxis.Title.Text = "Datetime";
            paneAcc.YAxis.Title.Text = "Accelerometer";
            paneTemp.YAxis.Title.Text = "Temperature";
            paneAlt.YAxis.Title.Text = "Altitute";
            zGraph_Acc.AxisChange();
            zGraph_Temp.AxisChange();
            zGraph_Alt.AxisChange();

            textBox1.AppendText("Download FINISHED" + System.Environment.NewLine);

            StreamWriter sw = new StreamWriter(@"C:\test.csv", false);
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
            panelButtons.Enabled = true;
            textBox1.AppendText("Stopped" + System.Environment.NewLine);
        }
        private void btnSet_Click(object sender, EventArgs e)
        {
            byte[] data = new byte[19];
            DateTime dateTimeVar = DateTime.Now;
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
            data[15] = 1; //1 seconds interval
            data[16] = 0;
            data[17] = 0;
            data[18] = 0;

            if (_chronos.SendSyncCommand(data))
                textBox1.AppendText("ezWatch setup OK" + System.Environment.NewLine);
            else
                textBox1.AppendText("exWatch setup FAIL" + System.Environment.NewLine);
        }
        private void btnErase_Click(object sender, EventArgs e)
        {
            byte[] data = new byte[19];
            int i;

            data[0] = Constants.SYNC_AP_CMD_ERASE_MEMORY;
            for (i = 1; i <= 18; i++)
                data[1] = 0;
            if (_chronos.SendSyncCommand(data))
                textBox1.AppendText("Sent SYNC_AP_CMD_ERASE_MEMORY" + System.Environment.NewLine);
        }

        private void chronosExit()
        {
            byte[] data = new byte[19];
            int i;

            data[0] = Constants.SYNC_AP_CMD_EXIT;
            for (i = 1; i <= 18; i++)
                data[i] = 0;
            if (_chronos.SendSyncCommand(data))
            {
                textBox1.AppendText("Sent SYNC_AP_CMD_EXIT" + System.Environment.NewLine);
                Thread.Sleep(1000);
            }      
        }
        private void chronosGetId()
        {
            byte[] data = new byte[19];
            _chronos.GetID(out _chronosId);
            textBox1.AppendText(string.Concat("Chronos ID = ", _chronosId.ToString()) + System.Environment.NewLine);
            Thread.Sleep(500);
            _chronos.ReadSyncBuffer(out data);
            foreach (byte b in data)
            {
                textBox1.AppendText(string.Format("{0:X2} ", b));
            }
            textBox1.AppendText(System.Environment.NewLine);
        }
        private void chronosGetStatus()
        {
            byte[] data = new byte[19];
            SyncStatus syncStatus;
            int i;
            int noOfAttempt = 300;

            data[0] = Constants.SYNC_AP_CMD_GET_STATUS;
            for (i = 1; i <= 18; i++)
                data[i] = 0;
            if (_chronos.SendSyncCommand(data))
                textBox1.AppendText("Sent SYNC_AP_CMD_GET_STATUS" + System.Environment.NewLine);

            for (i = 1; i < noOfAttempt; i++)
            {
                _chronos.GetSyncBufferStatus(out syncStatus);
                if (syncStatus == SyncStatus.SYNC_USB_DATA_READY)
                {
                    _chronos.ReadSyncBuffer(out data);
                    foreach (byte b in data)
                    {
                        textBox1.AppendText(string.Format("{0:X2} ", b));
                    }
                    textBox1.AppendText(System.Environment.NewLine);

                    _dataParser.ParseStatus(data);
                    if (_dataParser.isStatusParserEnded())
                    {
                        textBox1.AppendText("DataLog mode = " + _dataParser.datalogMode.ToString() +
                            System.Environment.NewLine);
                        textBox1.AppendText("bytes Len = " + _dataParser.bytesReady.ToString() +
                            System.Environment.NewLine);
                        textBox1.AppendText("interval = " + _dataParser.dataSecInterval.ToString() + " seconds." +
                            System.Environment.NewLine);
                        textBox1.AppendText(_dataParser.day.ToString() + "/" + _dataParser.month.ToString() + "/" +
                            _dataParser.year.ToString() + "   " + _dataParser.hour.ToString() + ":" +
                            _dataParser.min.ToString() + ":" + _dataParser.sec.ToString() +
                            System.Environment.NewLine);
                        textBox1.AppendText("   Temp = " + _dataParser.dataTemp[0].ToString() +
                            "   Alt = " + _dataParser.dataAltitude[0].ToString() +
                            "   x = " + _dataParser.dataAccX[0].ToString() +
                            "   y = " + _dataParser.dataAccY[0].ToString() +
                            "   z = " + _dataParser.dataAccZ[0].ToString() +
                            System.Environment.NewLine);
                        break;
                    }
                    break;
                }
            }
        }

        #endregion Methods
    }
}
