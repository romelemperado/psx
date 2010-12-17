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
using System.Linq;
using System.Windows.Forms;

namespace Chronoswatch_Downloader
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new mainForm());
        }
    }
}
