function Countdown-Timer([int] $Minutes = 15)
{
  $End = (Get-Date).AddMinutes($Minutes)
  $Status = "Szünet!"
  $Seconds = $Minutes*60
  While ((Get-Date) -lt $End)  
    {
      Start-Sleep -Seconds 1
	
      $Time = $End - (Get-Date)
      $DisplayTime = "{0:d2}:{1:d2}" -f ($Time.Minutes), ($Time.Seconds)
      If ($Time.Minutes -lt 1)
         {
          $Status = "Mindjárt kezdünk!"
         }
      $PercentComplete = ($Time.TotalSeconds/$Seconds)*100

      Write-Progress -Activity $DisplayTime -Status $Status -PercentComplete $PercentComplete
    }
}

function Countdown-TimerGUI([int] $Minutes = 15)
{
  Add-Type -AssemblyName System.Windows.Forms

  $End = (Get-Date).AddMinutes($Minutes)
  $Status = "Szünet!"
  $Seconds = $Minutes*60

  $Counter_Form = New-Object System.Windows.Forms.Form
  $Counter_Form.Text = $Status
  $Counter_Form.Width = 800
  $Counter_Form.Height = 600
  $Counter_Form.StartPosition = "CenterScreen"

  $Counter_Label = New-Object System.Windows.Forms.Label
  $Counter_Label.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', '32')
  $Counter_Label.Location = New-Object System.Drawing.Point(280, 150)
  $Counter_Label.Name = 'Counter'
  $Counter_Label.Size = New-Object System.Drawing.Size(240,100)
  $Counter_Label.TabIndex = 1
  $Counter_Label.Text = ''
  $Counter_Label.TextAlign = 'MiddleCenter'

  $Counter_Progress = New-Object System.Windows.Forms.ProgressBar
  $Counter_Progress.Maximum = 100
  $Counter_Progress.Minimum = 0
  $Counter_Progress.Location = New-Object System.Drawing.Point(150, 300)
  $Counter_Progress.Size = New-Object System.Drawing.Size(500,20)
  $Counter_Progress.Value = 100

  $Counter_Form.Controls.Add($Counter_Label)
  $Counter_Form.Controls.Add($Counter_Progress)
  $Counter_Form.Show()

  While ((Get-Date) -lt $End)  
    {
      $Time = $End - (Get-Date)
      $DisplayTime = "{0:d2}:{1:d2}" -f ($Time.Minutes), ($Time.Seconds)

      If ($Time.Minutes -lt 1)
         {
          $Status = "Mindjárt kezdünk!"
         }

      $PercentComplete = ($Time.TotalSeconds/$Seconds)*100

      $Counter_Progress.Value = $PercentComplete
      $Counter_Label.Text = $DisplayTime 
      $Counter_Form.Text = $Status

      Start-Sleep -Seconds 1
    }

  $Counter_Form.Close() 
}