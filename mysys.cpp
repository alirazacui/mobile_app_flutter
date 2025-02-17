#include <iostream>
#include <cstdlib>  // For rand()
#include <ctime>    // For seeding random numbers
using namespace std;

class User {
public:
    int userID;
    string name;
    double balance;
    User* next;
    
    User(int id, string n) : userID(id), name(n), balance(0.0), next(nullptr) {}
    
    void displayInfo() {
        cout << "User ID: " << userID << ", Name: " << name 
             << ", Balance: " << balance << endl;
    }
};

class UserList {
private:
    User* head;
    int userCount;
    
public:
    UserList() : head(nullptr), userCount(0) {}
    
    void addUser() {
        string name;
        cout << "Enter user name: ";
        cin >> name;
        userCount++;
        
        User* newUser = new User(userCount, name);
        if (!head)
            head = newUser;
        else {
            User* temp = head;
            while (temp->next)
                temp = temp->next;
            temp->next = newUser;
        }
        cout << "User " << name << " added successfully!\n";
    }
    
    void displayUsers() {
        User* temp = head;
        cout << "Chit Fund Members:\n";
        while (temp) {
            temp->displayInfo();
            temp = temp->next;
        }
    }
    
    User* getHead() { return head; }
};

class Transaction {
public:
    int transactionID;
    int userID;
    double amount;
    string type;
    Transaction* next;
    
    Transaction(int tID, int uID, double amt, string t)
        : transactionID(tID), userID(uID), amount(amt), type(t), next(nullptr) {}
    
    void displayTransaction() {
        cout << "Transaction ID: " << transactionID << ", User ID: " << userID
             << ", Amount: " << amount << ", Type: " << type << endl;
    }
};

class TransactionList {
private:
    Transaction* head;
    int transactionCount;
    
public:
    TransactionList() : head(nullptr), transactionCount(0) {}
    
    void addTransaction(int userID, double amount, string type) {
        transactionCount++;
        Transaction* newTransaction = new Transaction(transactionCount, userID, amount, type);
        if (!head)
            head = newTransaction;
        else {
            Transaction* temp = head;
            while (temp->next)
                temp = temp->next;
            temp->next = newTransaction;
        }
    }
    
    void displayTransactions() {
        Transaction* temp = head;
        cout << "Transaction History:\n";
        while (temp) {
            temp->displayTransaction();
            temp = temp->next;
        }
    }
};

struct WinnerNode {
    int userID;
    WinnerNode* next;
    
    WinnerNode(int id) : userID(id), next(nullptr) {}
};

class WinnerList {
private:
    WinnerNode* head;
    
public:
    WinnerList() : head(nullptr) {}
    
    void addWinner(int id) {
        WinnerNode* newNode = new WinnerNode(id);
        newNode->next = head;
        head = newNode;
    }
    
    bool isWinnerSelected(int id) {
        WinnerNode* temp = head;
        while (temp) {
            if (temp->userID == id)
                return true;
            temp = temp->next;
        }
        return false;
    }
    
    void clearWinners() {
        while (head) {
            WinnerNode* temp = head;
            head = head->next;
            delete temp;
        }
    }
    
    bool allUsersSelected(int totalUsers) {
        int count = 0;
        WinnerNode* temp = head;
        while (temp) {
            count++;
            temp = temp->next;
        }
        return count == totalUsers;
    }
};

class ChitFund {
private:
    UserList users;
    TransactionList transactions;
    double contributionAmount;
    string periodType;    // "Weekly" or "Monthly"
    int totalCycles;      // Number of cycles per payout round (e.g., 3 weeks)
    int currentCycle;     // Contributions collected in the current round
    int currentRound;     // Number of payout rounds completed so far
    int totalRounds;      // Total payout rounds (equal to number of members)
    WinnerList winnerTracker;
    
public:
    ChitFund() : contributionAmount(0), totalCycles(0), currentCycle(0), 
                 currentRound(0), totalRounds(0) {
        srand(time(0));
    }
    
    void setupFund() {
        cout << "Choose contribution period: \n1. Weekly\n2. Monthly\nEnter choice (1/2): ";
        int choice;
        cin >> choice;
        periodType = (choice == 1) ? "Weekly" : "Monthly";
        cout << "Enter number of " << periodType << "s per payout round: ";
        cin >> totalCycles;
        cout << "Enter contribution amount per cycle: ";
        cin >> contributionAmount;
        cout << "Chit fund set: Each payout round requires " << totalCycles 
             << " cycles of contributions with Rs. " << contributionAmount 
             << " per member per cycle.\n";
    }
    
    void addMembers() {
        int num;
        cout << "Enter number of members: ";
        cin >> num;
        for (int i = 0; i < num; i++) {
            users.addUser();
        }
        totalRounds = num;  // Each member will eventually receive a payout
        cout << "Total payout rounds: " << totalRounds << "\n";
    }
    
    // Collect contributions for one cycle in the current round.
    void collectContributions() {
        if (currentRound >= totalRounds) {
            cout << "All payout rounds are completed.\n";
            return;
        }
        if (currentCycle >= totalCycles) {
            cout << "Contributions for round " << (currentRound + 1) 
                 << " are already collected. Please distribute payout.\n";
            return;
        }
        
        cout << "Collecting contributions for " << periodType << " " 
             << (currentCycle + 1) << " in round " << (currentRound + 1) << "...\n";
        User* temp = users.getHead();
        while (temp) {
            transactions.addTransaction(temp->userID, contributionAmount, "Deposit");
            temp->balance += contributionAmount;
            temp = temp->next;
        }
        currentCycle++;
        cout << "Contributions collected successfully! (" << currentCycle << "/" 
             << totalCycles << " cycles completed in round " << (currentRound + 1) << ")\n";
    }
    
    // Returns the total number of users.
    int countUsers() {
        int count = 0;
        User* temp = users.getHead();
        while (temp) {
            count++;
            temp = temp->next;
        }
        return count;
    }
    
    // Returns a random user ID.
    int getRandomUserID() {
        int totalUsers = countUsers();
        if (totalUsers == 0)
            return -1;
        int randIndex = rand() % totalUsers;
        User* temp = users.getHead();
        for (int i = 0; i < randIndex && temp; i++) {
            temp = temp->next;
        }
        return temp ? temp->userID : -1;
    }
    
    // Distribute payout if all cycles for the current round have been collected.
    void distributePayout() {
        if (currentRound >= totalRounds) {
            cout << "All payout rounds are completed.\n";
            return;
        }
        if (currentCycle < totalCycles) {
            cout << "Error: Not all contributions collected in round " 
                 << (currentRound + 1) << " (" << currentCycle << "/" 
                 << totalCycles << " cycles).\n";
            return;
        }
        
        // Calculate the total pool for this round.
        double totalPool = contributionAmount * countUsers() * totalCycles;
        int winnerID = selectRandomWinner();
        User* winner = findUserByID(winnerID);
        if (winner) {
            cout << periodType << " Payout Round " << (currentRound + 1) 
                 << ": Payout given to " << winner->name 
                 << " (Total pool: " << totalPool << ")\n";
            transactions.addTransaction(winner->userID, totalPool, "Payout");
            // Adjust the winner's balance (here subtracting the payout, adjust as needed).
            winner->balance -= totalPool;
        }
        // Reset for the next payout round.
        currentCycle = 0;
        currentRound++;
    }
    
    // Select a random winner (ensuring no repetition until all have won once).
    int selectRandomWinner() {
        int totalUsers = countUsers();
        if (winnerTracker.allUsersSelected(totalUsers))
            winnerTracker.clearWinners();
        int winnerID;
        do {
            winnerID = getRandomUserID();
        } while (winnerTracker.isWinnerSelected(winnerID));
        winnerTracker.addWinner(winnerID);
        return winnerID;
    }
    
    User* findUserByID(int id) {
        User* temp = users.getHead();
        while (temp) {
            if (temp->userID == id)
                return temp;
            temp = temp->next;
        }
        return nullptr;
    }
};

int main() {
    ChitFund chitFund;
    chitFund.setupFund();
    chitFund.addMembers();
    
    int choice;
    do {
        cout << "\n===== Chit Fund Menu =====\n";
        cout << "1. Collect Contributions\n";
        cout << "2. Distribute Payout\n";
        cout << "3. Exit\n";
        cout << "Enter choice: ";
        cin >> choice;
        if (choice == 1)
            chitFund.collectContributions();
        else if (choice == 2)
            chitFund.distributePayout();
        else {
            
        }
    } while (choice != 3);
    
    return 0;
}
