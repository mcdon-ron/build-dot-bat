using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace HelloWorld
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void btnHelloWorld_Click(object sender, EventArgs e)
        {
            var json = "{ message: 'Hello World!' }";
            var msg = JsonConvert.DeserializeObject<MessageContainer>(json);

            MessageBox.Show(msg.Message);
        }
    }
}
