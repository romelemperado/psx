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
using System.Text;
using eZ430ChronosNet;

namespace CalorieLogger
{
    class DataParser
    {
        #region Enums
        enum DataParserType : byte
        {
            HEADER_0 = 0,
            HEADER_1 = 1,
            DATAMODE,
            INTERVAL,
            DAY,
            MONTH,
            YEAR_0,
            YEAR_1,
            HOUR,
            MINUTE,
            SECOND,
            DATA,
            BYTES_READY1, BYTES_READY2,
            END
        }

        enum ChronosDataType : byte
        {
            TEMP1, TEMP2,
            TEMP_ALTITUDE,
            ALTITUDE1, ALTITUDE2,
            ACC_X,
            ACC_Y,
            ACC_Z
        }
        #endregion Enums

        #region Constants
        const uint MAX_DATA_LEN = 2048;
        #endregion Constants

        #region Data Members
        int _dataCount;
        DateTime _timestamp;
        bool _isEnd;
        bool _isStatusParserEnd;
        ChronosDataType _chronosDataType;
        ChronosDataType _chronosStatusDataType;
        DataParserType _dataParserType;
        DataParserType _statusParserType;

        public int[] dataTemp, dataAltitude, dataAccX, dataAccY, dataAccZ;
        public DateTime[] dataTimestamp;
        public byte dataSecInterval;
        public int hour, min, sec, day, month, year;
        public byte datalogMode;
        public int bytesReady;
        public byte isUseMetric;
        #endregion Data Members

        #region Methods
        /// <summary>
        /// Constructor
        /// </summary>
        public DataParser()
        {
            resetDataParser();
            isUseMetric = 1;
            resetStatusParser();
            bytesReady = 0;
            hour = 0; min = 0; sec = 0; day = 1; month = 1; year = 1970;
            datalogMode = 0;
            dataSecInterval = 0;
            dataTemp = new int[MAX_DATA_LEN];
            dataAltitude = new int[MAX_DATA_LEN];
            dataAccX = new int[MAX_DATA_LEN];
            dataAccY = new int[MAX_DATA_LEN];
            dataAccZ = new int[MAX_DATA_LEN];
            dataTimestamp = new DateTime[MAX_DATA_LEN];
            _dataCount = 0;
            _timestamp = new DateTime();
        }

        /// <summary>
        /// Function to check if the Status Parser ended
        /// </summary>
        /// <returns></returns>
        public bool isStatusParserEnded()
        {
            return _isStatusParserEnd;
        }

        /// <summary>
        /// Function to reset the Status Parser
        /// </summary>
        public void resetStatusParser()
        {
            _isStatusParserEnd = false;
            _chronosStatusDataType = ChronosDataType.TEMP1;
            _statusParserType = DataParserType.HOUR;
        }

        /// <summary>
        /// Function to check the number of data to be downloaded
        /// </summary>
        /// <returns></returns>
        public int GetDataCount()
        {
            return _dataCount;
        }

        /// <summary>
        /// Function to reset the Data Parser
        /// </summary>
        public void resetDataParser()
        {
            _isEnd = false;
            _chronosDataType = ChronosDataType.TEMP1;
            _dataParserType = DataParserType.HEADER_0;
        }

        /// <summary>
        /// Function to check if the Data Parser ended
        /// </summary>
        /// <returns></returns>
        public bool isEnded()
        {
            return _isEnd;
        }

        /// <summary>
        /// Call this function to parse the status
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool ParseStatus(byte[] data)
        {
            int i;
            for (i = 1; i < data.Length; i++)
            {
                switch (_statusParserType)
                {
                    case DataParserType.HOUR:
                        isUseMetric = (byte)((data[i] & 0x80) >> 7);
                        hour = (byte)(data[i] & 0x7F);
                        _statusParserType = DataParserType.MINUTE;
                        break;
                    case DataParserType.MINUTE:
                        min = data[i];
                        _statusParserType = DataParserType.SECOND;
                        break;
                    case DataParserType.SECOND:
                        sec = data[i];
                        _statusParserType = DataParserType.YEAR_0;
                        break;
                    case DataParserType.YEAR_0:
                        year = (int)(data[i] << 8);
                        _statusParserType = DataParserType.YEAR_1;
                        break;
                    case DataParserType.YEAR_1:
                        year += (int)(data[i]);
                        _statusParserType = DataParserType.MONTH;
                        break;
                    case DataParserType.MONTH:
                        month = data[i];
                        _statusParserType = DataParserType.DAY;
                        break;
                    case DataParserType.DAY:
                        day = data[i];
                        _statusParserType = DataParserType.HEADER_0;
                        break;
                    case DataParserType.HEADER_0:
                        if (data[i] == 0)
                        {
                            _statusParserType = DataParserType.HEADER_1;
                        }
                        else
                        {
                            //wrong packet.... return to the first one
                            _statusParserType = DataParserType.HOUR;
                        }
                        break;
                    case DataParserType.HEADER_1:
                         if (data[i] == 0)
                        {
                            _statusParserType = DataParserType.DATA;
                            _chronosStatusDataType = ChronosDataType.TEMP1;
                        }
                        else
                        {
                            //wrong packet.... return to the first one
                            _statusParserType = DataParserType.HOUR;
                        }
                        break;
                    case DataParserType.DATA:
                        switch (_chronosStatusDataType)
                        {
                            case ChronosDataType.TEMP1:
                                dataTemp[0] = (int)(((uint)data[i]) << 8);
                                _chronosStatusDataType = ChronosDataType.TEMP2;
                                break;
                            case ChronosDataType.TEMP2:
                                dataTemp[0] += data[i];
                                _chronosStatusDataType = ChronosDataType.ALTITUDE1;
                                break;
                            case ChronosDataType.ALTITUDE1:
                                dataAltitude[0] = (int)(((uint)data[i]) << 8);
                                _chronosStatusDataType = ChronosDataType.ALTITUDE2;
                                break;
                            case ChronosDataType.ALTITUDE2:
                                dataAltitude[0] += data[i];
                                _statusParserType = DataParserType.DATAMODE;
                                break;
                        }
                        break;
                    case DataParserType.DATAMODE:
                        datalogMode = data[i];
                        _statusParserType = DataParserType.INTERVAL;
                        break;
                    case DataParserType.INTERVAL:
                        dataSecInterval = data[i];
                        _statusParserType = DataParserType.BYTES_READY1;
                        break;
                    case DataParserType.BYTES_READY1:
                        bytesReady = (int)(((uint)data[i]) << 8);
                        _statusParserType = DataParserType.BYTES_READY2;
                        break;
                    case DataParserType.BYTES_READY2:
                        bytesReady += data[i];
                        _statusParserType = DataParserType.END;
                        break;
                    case DataParserType.END:
                        _statusParserType = DataParserType.HOUR;
                        _isStatusParserEnd = true;
                        _chronosStatusDataType = ChronosDataType.TEMP1;
                        break;
                }
            }
            return true;
        }

        /// <summary>
        /// Call this function to parse the data
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool ParseData(byte[] data)
        {
            int i;
            for (i = 3; i < data.Length; i++)
            {
                switch (_dataParserType)
                {
                    case DataParserType.HEADER_0:
                        if (data[i] == 0xFB)
                            _dataParserType = DataParserType.HEADER_1;
                        break;
                    case DataParserType.HEADER_1:
                        if (data[i] == 0xFF)
                            _dataParserType = DataParserType.DATAMODE;
                        else
                        {
                            _dataParserType = DataParserType.HEADER_0;
                            _isEnd = true;
                        }
                        break;
                    case DataParserType.DATAMODE:
                        datalogMode = data[i];
                        _dataParserType = DataParserType.INTERVAL;
                        break;
                    case DataParserType.INTERVAL:
                        dataSecInterval = data[i];
                        _dataParserType = DataParserType.DAY;
                        break;
                    case DataParserType.DAY:
                        day = data[i];
                        _dataParserType = DataParserType.MONTH;
                        break;
                    case DataParserType.MONTH:
                        month = data[i];
                        _dataParserType = DataParserType.YEAR_0;
                        break;
                    case DataParserType.YEAR_0:
                        year = data[i];
                        _dataParserType = DataParserType.YEAR_1;
                        break;
                    case DataParserType.YEAR_1:
                        year += (int)(((uint)data[i]) << 8);
                        _dataParserType = DataParserType.HOUR;
                        break;
                    case DataParserType.HOUR:
                        hour = data[i];
                        _dataParserType = DataParserType.MINUTE;
                        break;
                    case DataParserType.MINUTE:
                        min = data[i];
                        _dataParserType = DataParserType.SECOND;
                        break;
                    case DataParserType.SECOND:
                        sec = data[i];
                        _dataParserType = DataParserType.DATA;
                        _timestamp = new DateTime(year, month, day, hour, min, sec);
                        _timestamp = _timestamp.AddSeconds(-1 * dataSecInterval);
                        _chronosDataType = ChronosDataType.TEMP1;
                        break;
                    case DataParserType.END:
                        if (data[i] == 0xFF)
                        {
                            _dataParserType = DataParserType.HEADER_0;
                            break;
                        }
                        else
                        {
                            _dataParserType = DataParserType.DATA;
                        }
                        goto case DataParserType.DATA;
                    case DataParserType.DATA:
                        switch (_chronosDataType)
                        {
                            case ChronosDataType.TEMP1:
                                _timestamp = _timestamp.AddSeconds(dataSecInterval);
                                dataTimestamp[_dataCount] = _timestamp;

                                dataTemp[_dataCount] = (int)(((uint)data[i] & 0xFF) << 4);
                                _chronosDataType = ChronosDataType.TEMP_ALTITUDE;
                                break;
                            case ChronosDataType.TEMP_ALTITUDE:
                                dataTemp[_dataCount] += (int)((data[i] & 0xF0) >> 4);
                                dataAltitude[_dataCount] = (int)((data[i] & 0x0F) << 8);
                                _chronosDataType = ChronosDataType.ALTITUDE1;
                                break;
                            case ChronosDataType.ALTITUDE1:
                                dataAltitude[_dataCount] += (int)(data[i] & 0xFF);
                                _chronosDataType = ChronosDataType.ACC_X;
                                break;
                            case ChronosDataType.ACC_X:
                                dataAccX[_dataCount] = (int)data[i];
                                _chronosDataType = ChronosDataType.ACC_Y;
                                break;
                            case ChronosDataType.ACC_Y:
                                dataAccY[_dataCount] = (int)data[i];
                                _chronosDataType = ChronosDataType.ACC_Z;
                                break;
                            case ChronosDataType.ACC_Z:
                                dataAccZ[_dataCount] = (int)data[i];
                                _chronosDataType = ChronosDataType.TEMP1;
                                _dataCount++;
                                break;
                        }
                        if (_dataCount >= MAX_DATA_LEN)
                        {
                            //overflow... exit to HEADER_0 and drop others
                            _dataParserType = DataParserType.HEADER_0;
                        }
                        if (data[i] == 0xFE)
                            _dataParserType = DataParserType.END;
                        break;
                    
                }
            }
            return true;
        }
        #endregion Methods
    }
}
