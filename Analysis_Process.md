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

1.  [cite_start]Begin by plugging in the device and trusting it[cite: 22].
2.  [cite_start]Sign in to iTunes with the account of the device[cite: 23].
3.  [cite_start]A small phone icon will appear in the top left, next to the music button[cite: 24].
4.  If prompted to "set up new iPhone" or "restore from backup," choose "set up new iPhone." [cite_start]This registers the phone to the laptop without wiping any data[cite: 25].
5.  [cite_start]Once registered, you can access the summary section from the left-hand side menu bar[cite: 26].
6.  [cite_start]In the "Backups" section, under "automatically back up," select "this computer" and "encrypt local backup"[cite: 27].
7.  [cite_start]Set the password to "admin" for ease of use[cite: 28].
8.  [cite_start]If the backup doesn't start automatically, you can use the "generate manual backup" button in the same section[cite: 29].
9.  [cite_start]Backups are stored in `C:\Users\[your username]\AppData\Roaming\Apple Computer\MobileSync\Backup`[cite: 30].

### [cite_start]Dump Syslogs [cite: 31]
#### [cite_start]Use ilibmobile package (Ubuntu) [cite: 32]
[cite_start]This method is performed on the server and requires being in the `tools.venv` python environment[cite: 33]. [cite_start]The steps are as follows[cite: 34]:
* [cite_start]Use the `idevicecrashreport` command to dump all logs to a directory[cite: 35]. [cite_start]The command is `idevicecrashreport -u <uuid> -k <dest>`[cite: 36].

#### [cite_start]Use MacOS [cite: 37]
* [cite_start]Dumping logs with macOS is easy using the `log` command[cite: 38].
* [cite_start]You can then use the command to analyze different parts or types of logs[cite: 39].

### [cite_start]Decrypt/Check Backup with mvt-ios [cite: 40]
[cite_start]Decrypting backups is a straightforward, two-step process[cite: 41]. [cite_start]The initial backups are all in UUID format, which are your targets[cite: 42].

* [cite_start]**Step 1:** Perform a backup decryption using the `backup-decrypt` command[cite: 43]. [cite_start]The command is `mvt-ios decrypt-backup -d <dest> </path/to/backup>`[cite: 44].
* [cite_start]**Step 2:** Check some of the data using `check-backup`[cite: 45]. [cite_start]The command is `mvt-ios check-backup --output <dest> </path/to/backup>`[cite: 46].

### [cite_start]Process Syslogs [cite: 47]
* [cite_start]Use a Mac OS device to process the logs with the `AUL_Creator.sh` script, which can output to `log`, `json`, and `jsonl`[cite: 48].
* [cite_start]**Step 1:** Get your log files from the following locations[cite: 49, 50, 51, 52]:
    * [cite_start]`/private/var/db/diagnostics` [cite: 50]
    * [cite_start]`/private/var/db/uuidtext` [cite: 51]
    * [cite_start]`/Library/Logs/Crashreporter/MobileDevice/<Device Name>/DiagnosticLogs/Sysdiagnose` [cite: 52]

### [cite_start]Ingest Syslogs into SIEM [cite: 53]
* [cite_start]Access the `SIEM_SVR` via the URL `http://10.0.0.100:80` and use the web interface to load the `jsonl` files into the timesketch server[cite: 54].

### [cite_start]Ingest Logs into Streamlit [cite: 55]
