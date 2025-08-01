## Analysis Process 

### Rip Phone (Quick & FFS)
* Use one of the commercial tools.
* First, create an image of the device with a quick scan, then do a full file system rip
* To increase the chances of success, ensure the hardware is up to date
* Follow the individual setup requirements of the tools for successful data processing

### Create iTunes Backup
#### Use ilibmobile package (Ubuntu)
Using the `ilibmobiles idevicebackup2` to create the iTunes backup is the preferred method. To do this, make sure you are in the `tools.venv` python environment and follow these steps

1.  Establish trust between the iPhone and the server by interfacing with the iPhone
2.  Use the `idevice_id` command to find the UUID of the device[cite: 12].
3.  Turn on encryption and set the password to "admin" to ensure the most comprehensive backup The command is `idevicebackup2 encyption on admin`.
4.  Use the `idevicebackup2` command in the following format: `idevicebackup2 -u <uuid> backup --full <dest>`.
5.  A directory with the UUID of the device as its name should be created.
6.  It is good practice to turn off encryption after the process is complete with the command `idevicebackup2 encyption off admin`.

#### Use iTunes for Windows GUI 
Sometimes, due to issues with iOS versions and phones, alternative methods are needed. You can use iTunes that has been downloaded directly from the Apple website, not the Windows store, on analyst laptops

1.  Begin by plugging in the device and trusting it.
2.  Sign in to iTunes with the account of the device.
3.  A small phone icon will appear in the top left, next to the music button.
4.  If prompted to "set up new iPhone" or "restore from backup," choose "set up new iPhone." This registers the phone to the laptop without wiping any data.
5.  Once registered, you can access the summary section from the left-hand side menu bar.
6.  In the "Backups" section, under "automatically back up," select "this computer" and "encrypt local backup".
7.  Set the password to "admin" for ease of use.
8.  If the backup doesn't start automatically, you can use the "generate manual backup" button in the same section.
9.  Backups are stored in `C:\Users\[your username]\AppData\Roaming\Apple Computer\MobileSync\Backup`.

### Dump Syslogs 
#### Use ilibmobile package (Ubuntu)
This method is performed on the server and requires being in the `tools.venv` python environment. The steps are as follows:
* Use the `idevicecrashreport` command to dump all logs to a directory. The command is `idevicecrashreport -u <uuid> -k <dest>`.

#### Use MacOS 
* Dumping logs with macOS is easy using the `log` command.
* You can then use the command to analyze different parts or types of logs.

### Decrypt/Check Backup with mvt-ios 
Decrypting backups is a straightforward, two-step process. The initial backups are all in UUID format, which are your targets.

* **Step 1:** Perform a backup decryption using the `backup-decrypt` command. The command is `mvt-ios decrypt-backup -d <dest> </path/to/backup>`
* **Step 2:** Check some of the data using `check-backup`. The command is `mvt-ios check-backup --output <dest> </path/to/backup>`
### Process Syslogs 
* Use a Mac OS device to process the logs with the `AUL_Creator.sh` script, which can output to `log`, `json`, and `jsonl`.
* **Step 1:** Get your log files from the following locations:
    * `/private/var/db/diagnostics` 
    * `/private/var/db/uuidtext` 
    * `/Library/Logs/Crashreporter/MobileDevice/<Device Name>/DiagnosticLogs/Sysdiagnose` 

### Ingest Syslogs into SIEM 
* Access the `SIEM_SVR` via the URL `http://10.0.0.100:80` and use the web interface to load the `jsonl` files into the timesketch server.

### [cite_start]Ingest Logs into Streamlit 
