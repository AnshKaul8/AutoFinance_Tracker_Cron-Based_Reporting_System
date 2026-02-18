AutoFinance_Tracker_Cron-Based_Reporting_System

Managing personal finances is an essential part of everyday life.However,many people struggle to track expenses,categorize spending,analyze trends,or monitor investments effectively.Manual finance tracking is often time-consuming, unorganized,and prone to errors.

To address these challenges,the project was developed using **Linux Shell Scripting (Bash)**.  This project provides an interactive command-line system that automates daily expense recording, budget monitoring, report generation, and investment tracking in an organized and efficient manner.

The system stores all expenses, categories, and investments in structured files such as **CSV** and **TXT** formats. Users can:

- Add daily expenses with categories  
- Generate daily and monthly reports  
- Check budget limits and receive alerts  
- Track basic investments  
- Visualize spending trends using graphs  

Automation through **cron jobs** ensures that daily reports can be generated automatically without manual effort.

### Expense Management
- Add expenses with date, category, description, and amount  
- Store records in CSV format for easy tracking  

### Reports
- **Category-wise Report**: Displays spending per category  
- **Daily Report**: Shows daily totals and breakdown  
- **Monthly Report**: Summarizes monthly spending (stored in `/reports`)  

### Budget Checking
- Alerts the user if a category or investment exceeds predefined limits  

### Investment Manager
- Tracks investments such as:
  - Fixed Deposits (FDs)  
  - SIPs  
  - Stocks  
- Supports notes and structured storage  

### Graph Generation
- Creates PNG graphs of daily spending using **Gnuplot**  

### Automation
- Cron job support for automatic daily report generation at midnight  

### Software Requirements
- Linux OS (Ubuntu / Fedora / Kali / Arch)  
- Bash Shell (version 4+)  
- AWK and sed utilities  
- Gnuplot (for graph generation)  
- Cron service enabled  
- Text editor (nano / vim / VS Code)  

### Hardware Requirements
- Minimum 2 GB RAM  
- ~10 MB storage space  
- Any modern CPU  

### Future Enhancements

The project can be extended further by incorporating:

- Email-based report alerts  
- Multi-user functionality  
- Database integration  
- Predictive financial analytics  

## How to Run the Project

1. Clone the repository:

```bash
git clone https://github.com/AnshKaul8/AutoFinance_Tracker_Cron-Based_Reporting_System.git
cd AutoFinance_Tracker_Cron-Based_Reporting_System

2. Make the script executable
chmod +x financemanager.sh

3. Run the Personal Finance Manager:
./financemanager.sh


