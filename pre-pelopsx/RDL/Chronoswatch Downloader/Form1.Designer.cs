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
namespace Chronoswatch_Downloader
{
    partial class mainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(mainForm));
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.progressBarDL = new System.Windows.Forms.ProgressBar();
            this.panelButtons = new System.Windows.Forms.Panel();
            this.btnDownload = new System.Windows.Forms.Button();
            this.btnErase = new System.Windows.Forms.Button();
            this.btnSet = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.zGraph_Acc = new ZedGraph.ZedGraphControl();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.zGraph_Temp = new ZedGraph.ZedGraphControl();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.zGraph_Alt = new ZedGraph.ZedGraphControl();
            this.tabPage5 = new System.Windows.Forms.TabPage();
            this.labelDisclamer = new System.Windows.Forms.Label();
            this.richTextBoxDisclaimer = new System.Windows.Forms.RichTextBox();
            this.richTextBoxAbout = new System.Windows.Forms.RichTextBox();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.panelButtons.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabPage3.SuspendLayout();
            this.tabPage4.SuspendLayout();
            this.tabPage5.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabPage3);
            this.tabControl1.Controls.Add(this.tabPage4);
            this.tabControl1.Controls.Add(this.tabPage5);
            this.tabControl1.Location = new System.Drawing.Point(12, 12);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(878, 343);
            this.tabControl1.TabIndex = 4;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.progressBarDL);
            this.tabPage1.Controls.Add(this.panelButtons);
            this.tabPage1.Controls.Add(this.textBox1);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(870, 317);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Controlbox";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // progressBarDL
            // 
            this.progressBarDL.Location = new System.Drawing.Point(6, 284);
            this.progressBarDL.Name = "progressBarDL";
            this.progressBarDL.Size = new System.Drawing.Size(586, 17);
            this.progressBarDL.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressBarDL.TabIndex = 5;
            this.progressBarDL.Value = 10;
            // 
            // panelButtons
            // 
            this.panelButtons.Controls.Add(this.btnDownload);
            this.panelButtons.Controls.Add(this.btnErase);
            this.panelButtons.Controls.Add(this.btnSet);
            this.panelButtons.Location = new System.Drawing.Point(611, 20);
            this.panelButtons.Name = "panelButtons";
            this.panelButtons.Size = new System.Drawing.Size(167, 175);
            this.panelButtons.TabIndex = 4;
            // 
            // btnDownload
            // 
            this.btnDownload.Location = new System.Drawing.Point(24, 13);
            this.btnDownload.Name = "btnDownload";
            this.btnDownload.Size = new System.Drawing.Size(117, 23);
            this.btnDownload.TabIndex = 5;
            this.btnDownload.Text = "Download Now";
            this.btnDownload.UseVisualStyleBackColor = true;
            this.btnDownload.Click += new System.EventHandler(this.btnDownload_Click);
            // 
            // btnErase
            // 
            this.btnErase.Location = new System.Drawing.Point(25, 141);
            this.btnErase.Name = "btnErase";
            this.btnErase.Size = new System.Drawing.Size(118, 21);
            this.btnErase.TabIndex = 4;
            this.btnErase.Text = "Erase";
            this.btnErase.UseVisualStyleBackColor = true;
            this.btnErase.Click += new System.EventHandler(this.btnErase_Click);
            // 
            // btnSet
            // 
            this.btnSet.Location = new System.Drawing.Point(25, 74);
            this.btnSet.Name = "btnSet";
            this.btnSet.Size = new System.Drawing.Size(116, 24);
            this.btnSet.TabIndex = 2;
            this.btnSet.Text = "Set Mode Now";
            this.btnSet.UseVisualStyleBackColor = true;
            this.btnSet.Click += new System.EventHandler(this.btnSet_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(6, 20);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ReadOnly = true;
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBox1.Size = new System.Drawing.Size(586, 258);
            this.textBox1.TabIndex = 3;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.zGraph_Acc);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(870, 317);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Acceleration";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // zGraph_Acc
            // 
            this.zGraph_Acc.AutoScroll = true;
            this.zGraph_Acc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.zGraph_Acc.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.zGraph_Acc.Location = new System.Drawing.Point(8, 6);
            this.zGraph_Acc.Margin = new System.Windows.Forms.Padding(5, 6, 5, 6);
            this.zGraph_Acc.Name = "zGraph_Acc";
            this.zGraph_Acc.ScrollGrace = 0D;
            this.zGraph_Acc.ScrollMaxX = 0D;
            this.zGraph_Acc.ScrollMaxY = 0D;
            this.zGraph_Acc.ScrollMaxY2 = 0D;
            this.zGraph_Acc.ScrollMinX = 0D;
            this.zGraph_Acc.ScrollMinY = 0D;
            this.zGraph_Acc.ScrollMinY2 = 0D;
            this.zGraph_Acc.Size = new System.Drawing.Size(854, 302);
            this.zGraph_Acc.TabIndex = 0;
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.zGraph_Temp);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage3.Size = new System.Drawing.Size(870, 317);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Temperature";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // zGraph_Temp
            // 
            this.zGraph_Temp.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.zGraph_Temp.Location = new System.Drawing.Point(10, 11);
            this.zGraph_Temp.Margin = new System.Windows.Forms.Padding(7, 8, 7, 8);
            this.zGraph_Temp.Name = "zGraph_Temp";
            this.zGraph_Temp.ScrollGrace = 0D;
            this.zGraph_Temp.ScrollMaxX = 0D;
            this.zGraph_Temp.ScrollMaxY = 0D;
            this.zGraph_Temp.ScrollMaxY2 = 0D;
            this.zGraph_Temp.ScrollMinX = 0D;
            this.zGraph_Temp.ScrollMinY = 0D;
            this.zGraph_Temp.ScrollMinY2 = 0D;
            this.zGraph_Temp.Size = new System.Drawing.Size(850, 295);
            this.zGraph_Temp.TabIndex = 2;
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.zGraph_Alt);
            this.tabPage4.Location = new System.Drawing.Point(4, 22);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage4.Size = new System.Drawing.Size(870, 317);
            this.tabPage4.TabIndex = 3;
            this.tabPage4.Text = "Altitute";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // zGraph_Alt
            // 
            this.zGraph_Alt.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.zGraph_Alt.Location = new System.Drawing.Point(10, 11);
            this.zGraph_Alt.Margin = new System.Windows.Forms.Padding(7, 8, 7, 8);
            this.zGraph_Alt.Name = "zGraph_Alt";
            this.zGraph_Alt.ScrollGrace = 0D;
            this.zGraph_Alt.ScrollMaxX = 0D;
            this.zGraph_Alt.ScrollMaxY = 0D;
            this.zGraph_Alt.ScrollMaxY2 = 0D;
            this.zGraph_Alt.ScrollMinX = 0D;
            this.zGraph_Alt.ScrollMinY = 0D;
            this.zGraph_Alt.ScrollMinY2 = 0D;
            this.zGraph_Alt.Size = new System.Drawing.Size(853, 295);
            this.zGraph_Alt.TabIndex = 3;
            // 
            // tabPage5
            // 
            this.tabPage5.BackColor = System.Drawing.SystemColors.ControlLight;
            this.tabPage5.Controls.Add(this.richTextBoxAbout);
            this.tabPage5.Controls.Add(this.richTextBoxDisclaimer);
            this.tabPage5.Controls.Add(this.labelDisclamer);
            this.tabPage5.Location = new System.Drawing.Point(4, 22);
            this.tabPage5.Name = "tabPage5";
            this.tabPage5.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage5.Size = new System.Drawing.Size(870, 317);
            this.tabPage5.TabIndex = 4;
            this.tabPage5.Text = "About";
            // 
            // labelDisclamer
            // 
            this.labelDisclamer.AutoSize = true;
            this.labelDisclamer.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelDisclamer.Location = new System.Drawing.Point(742, 185);
            this.labelDisclamer.Name = "labelDisclamer";
            this.labelDisclamer.Size = new System.Drawing.Size(125, 26);
            this.labelDisclamer.TabIndex = 1;
            this.labelDisclamer.Text = "Disclaimer";
            // 
            // richTextBoxDisclaimer
            // 
            this.richTextBoxDisclaimer.BackColor = System.Drawing.SystemColors.ControlLight;
            this.richTextBoxDisclaimer.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.richTextBoxDisclaimer.Location = new System.Drawing.Point(198, 214);
            this.richTextBoxDisclaimer.Name = "richTextBoxDisclaimer";
            this.richTextBoxDisclaimer.ReadOnly = true;
            this.richTextBoxDisclaimer.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.richTextBoxDisclaimer.Size = new System.Drawing.Size(666, 84);
            this.richTextBoxDisclaimer.TabIndex = 2;
            this.richTextBoxDisclaimer.Text = resources.GetString("richTextBoxDisclaimer.Text");
            // 
            // richTextBoxAbout
            // 
            this.richTextBoxAbout.BackColor = System.Drawing.SystemColors.ControlLight;
            this.richTextBoxAbout.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.richTextBoxAbout.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.richTextBoxAbout.Location = new System.Drawing.Point(26, 18);
            this.richTextBoxAbout.Name = "richTextBoxAbout";
            this.richTextBoxAbout.ReadOnly = true;
            this.richTextBoxAbout.Size = new System.Drawing.Size(345, 88);
            this.richTextBoxAbout.TabIndex = 3;
            this.richTextBoxAbout.Text = "Author:    R. Voon\nWeb:       ruditronics.wordpress.com\nLicense:   Free";
            // 
            // mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(893, 366);
            this.Controls.Add(this.tabControl1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "mainForm";
            this.Text = "ez430Chronos Downloader";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.mainForm_FormClosing);
            this.Load += new System.EventHandler(this.mainForm_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.panelButtons.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            this.tabPage3.ResumeLayout(false);
            this.tabPage4.ResumeLayout(false);
            this.tabPage5.ResumeLayout(false);
            this.tabPage5.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TabPage tabPage2;
        private ZedGraph.ZedGraphControl zGraph_Acc;
        private System.Windows.Forms.ProgressBar progressBarDL;
        private System.Windows.Forms.Panel panelButtons;
        private System.Windows.Forms.Button btnDownload;
        private System.Windows.Forms.Button btnErase;
        private System.Windows.Forms.Button btnSet;
        private System.Windows.Forms.TabPage tabPage3;
        private ZedGraph.ZedGraphControl zGraph_Temp;
        private System.Windows.Forms.TabPage tabPage4;
        private ZedGraph.ZedGraphControl zGraph_Alt;
        private System.Windows.Forms.TabPage tabPage5;
        private System.Windows.Forms.RichTextBox richTextBoxAbout;
        private System.Windows.Forms.RichTextBox richTextBoxDisclaimer;
        private System.Windows.Forms.Label labelDisclamer;
    }
}

