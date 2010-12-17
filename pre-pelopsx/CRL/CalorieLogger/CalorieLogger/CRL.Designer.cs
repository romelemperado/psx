namespace CalorieLogger
{
    partial class CRL
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
            this.download = new System.Windows.Forms.Button();
            this.read = new System.Windows.Forms.Button();
            this.erase = new System.Windows.Forms.Button();
            this.sync = new System.Windows.Forms.Button();
            this.savedir = new System.Windows.Forms.TextBox();
            this.exit = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.browse = new System.Windows.Forms.Button();
            this.status = new System.Windows.Forms.TextBox();
            this.save = new System.Windows.Forms.SaveFileDialog();
            this.SuspendLayout();
            // 
            // download
            // 
            this.download.BackColor = System.Drawing.Color.Transparent;
            this.download.ForeColor = System.Drawing.Color.Black;
            this.download.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.download.Location = new System.Drawing.Point(270, 20);
            this.download.Name = "download";
            this.download.Size = new System.Drawing.Size(68, 50);
            this.download.TabIndex = 0;
            this.download.Text = "Download";
            this.download.UseVisualStyleBackColor = false;
            this.download.Click += new System.EventHandler(this.button1_Click);
            // 
            // read
            // 
            this.read.BackColor = System.Drawing.Color.Transparent;
            this.read.ForeColor = System.Drawing.Color.Black;
            this.read.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.read.Location = new System.Drawing.Point(61, 48);
            this.read.Name = "read";
            this.read.Size = new System.Drawing.Size(42, 22);
            this.read.TabIndex = 0;
            this.read.Text = "Read";
            this.read.UseVisualStyleBackColor = false;
            this.read.Click += new System.EventHandler(this.button2_Click);
            // 
            // erase
            // 
            this.erase.BackColor = System.Drawing.Color.Transparent;
            this.erase.ForeColor = System.Drawing.Color.Black;
            this.erase.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.erase.Location = new System.Drawing.Point(109, 48);
            this.erase.Name = "erase";
            this.erase.Size = new System.Drawing.Size(42, 22);
            this.erase.TabIndex = 0;
            this.erase.Text = "Erase";
            this.erase.UseVisualStyleBackColor = false;
            this.erase.Click += new System.EventHandler(this.button3_Click);
            // 
            // sync
            // 
            this.sync.BackColor = System.Drawing.Color.Transparent;
            this.sync.ForeColor = System.Drawing.Color.Black;
            this.sync.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.sync.Location = new System.Drawing.Point(13, 48);
            this.sync.Name = "sync";
            this.sync.Size = new System.Drawing.Size(42, 22);
            this.sync.TabIndex = 0;
            this.sync.Text = "Sync";
            this.sync.UseVisualStyleBackColor = false;
            this.sync.Click += new System.EventHandler(this.sync_Click);
            // 
            // savedir
            // 
            this.savedir.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.savedir.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.savedir.Location = new System.Drawing.Point(12, 22);
            this.savedir.Name = "savedir";
            this.savedir.Size = new System.Drawing.Size(252, 20);
            this.savedir.TabIndex = 1;
            // 
            // exit
            // 
            this.exit.Cursor = System.Windows.Forms.Cursors.Hand;
            this.exit.FlatAppearance.BorderSize = 0;
            this.exit.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.exit.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.exit.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.exit.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel, ((byte)(0)));
            this.exit.ForeColor = System.Drawing.Color.Red;
            this.exit.Location = new System.Drawing.Point(312, 71);
            this.exit.Name = "exit";
            this.exit.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.exit.Size = new System.Drawing.Size(31, 22);
            this.exit.TabIndex = 3;
            this.exit.Tag = "Exit";
            this.exit.Text = "Exit";
            this.exit.UseVisualStyleBackColor = true;
            this.exit.Click += new System.EventHandler(this.exit_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Black;
            this.label1.Location = new System.Drawing.Point(10, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 12);
            this.label1.TabIndex = 4;
            this.label1.Text = "Save data to:";
            // 
            // browse
            // 
            this.browse.BackColor = System.Drawing.Color.Transparent;
            this.browse.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.browse.ForeColor = System.Drawing.Color.Black;
            this.browse.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.browse.Location = new System.Drawing.Point(214, 48);
            this.browse.Name = "browse";
            this.browse.Size = new System.Drawing.Size(50, 22);
            this.browse.TabIndex = 0;
            this.browse.Text = "Browse";
            this.browse.UseVisualStyleBackColor = false;
            this.browse.Click += new System.EventHandler(this.button4_Click);
            // 
            // status
            // 
            this.status.AccessibleRole = System.Windows.Forms.AccessibleRole.StaticText;
            this.status.BackColor = System.Drawing.SystemColors.Control;
            this.status.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.status.Cursor = System.Windows.Forms.Cursors.Default;
            this.status.Location = new System.Drawing.Point(12, 75);
            this.status.Name = "status";
            this.status.Size = new System.Drawing.Size(304, 13);
            this.status.TabIndex = 1;
            // 
            // save
            // 
            this.save.Title = "Save";
            // 
            // CRL
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.ClientSize = new System.Drawing.Size(350, 95);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.exit);
            this.Controls.Add(this.status);
            this.Controls.Add(this.savedir);
            this.Controls.Add(this.sync);
            this.Controls.Add(this.browse);
            this.Controls.Add(this.erase);
            this.Controls.Add(this.read);
            this.Controls.Add(this.download);
            this.ForeColor = System.Drawing.Color.Red;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "CRL";
            this.RightToLeftLayout = true;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.CRL_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button download;
        private System.Windows.Forms.Button read;
        private System.Windows.Forms.Button erase;
        private System.Windows.Forms.Button sync;
        private System.Windows.Forms.TextBox savedir;
        private System.Windows.Forms.Button exit;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button browse;
        private System.Windows.Forms.TextBox status;
        private System.Windows.Forms.SaveFileDialog save;
    }
}