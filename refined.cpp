#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <ctime>
using namespace std;

struct Member {
    int id;
    string name;
    double balance;  // Add balance to track member contributions
    Member* next;
};

class ChitFund {
private:
    string fundName;
    double contributionAmount;
    int totalCycles;
    string periodType;
    int currentCycle;
    Member* members;
    bool collectionStarted;

public:
    ChitFund() : contributionAmount(0), totalCycles(0), currentCycle(0), 
                 members(nullptr), collectionStarted(false) {}

    void createNewFund() {
        cout << "Enter fund name: ";
        cin >> fundName;
        cout << "Choose contribution period: \n1. Weekly\n2. Monthly\nEnter choice (1/2): ";
        int choice;
        cin >> choice;
        periodType = (choice == 1) ? "Weekly" : "Monthly";
        cout << "Enter number of " << periodType << "s per payout round: ";
        cin >> totalCycles;
        cout << "Enter contribution amount per cycle: ";
        cin >> contributionAmount;
        
        int numMembers;
        cout << "Enter number of initial members: ";
        cin >> numMembers;
        
        for (int i = 0; i < numMembers; ++i) {
            addMember(true);
        }
        
        saveFundDetails();
    }

    void saveFundDetails() {
        ofstream fundFile(fundName + "_details.txt");
        fundFile << periodType << " " << totalCycles << " " << contributionAmount << " " << currentCycle << "\n";
        fundFile.close();
    }

    bool loadFund(string name) {
        fundName = name;
        ifstream fundFile(fundName + "_details.txt");
        if (!fundFile) {
            cout << "Fund not found!" << endl;
            return false;
        }
        fundFile >> periodType >> totalCycles >> contributionAmount >> currentCycle;
        fundFile.close();
        return true;
    }

    void addMember(bool fromCreation = false) {
        if (collectionStarted && !fromCreation) {
            cout << "Cannot add members after collections have started!" << endl;
            return;
        }
        
        string name;
        cout << "Enter user name: ";
        cin >> name;
        
        Member* newMember = new Member{countUsers() + 1, name, 0.0, nullptr};  // Set balance to 0 initially
        if (!members) {
            members = newMember;
        } else {
            Member* temp = members;
            while (temp->next) temp = temp->next;
            temp->next = newMember;
        }
        
        ofstream userFile(fundName + "_users.txt", ios::app);
        userFile << newMember->id << " " << name << " 0\n";
        userFile.close();
    }

    int countUsers() {
        ifstream userFile(fundName + "_users.txt");
        string line;
        int count = 0;
        while (getline(userFile, line)) count++;
        userFile.close();
        return count;
    }

    void collectContributions() {
        if (countUsers() == 0) {
            cout << "No members in the fund. Add members before collecting contributions!" << endl;
            return;
        }
        
        if (currentCycle >= totalCycles) {
            cout << "Contributions already collected for this round!" << endl;
            return;
        }
    
        // Collect contribution from each member
        collectionStarted = true;
        ofstream transFile(fundName + "_transactions.txt", ios::app);
        ifstream userFile(fundName + "_users.txt");
    
        int id;
        string name;
        double balance;
        bool allContributed = true;
    
        while (userFile >> id >> name >> balance) {
            cout << "Enter contribution for " << name << ": ";
            double contribution;
            cin >> contribution;
            balance += contribution;  // Update the balance with the contribution
    
            // Write transaction to the file
            transFile << id << " " << contribution << " Deposit\n";
    
            // Update user balance in the file
            updateUserBalance(id, balance);
    
            if (balance == 0) {
                allContributed = false;
            }
        }
        userFile.close();
        transFile.close();
        
        if (allContributed) {
            currentCycle++;
            cout << "Contributions collected for cycle " << currentCycle << "/" << totalCycles << endl;
        } else {
            cout << "All members must make their contributions before starting the collection!" << endl;
        }
    }
    
    

    void updateUserBalance(int userId, double newBalance) {
        ifstream userFile(fundName + "_users.txt");
        ofstream tempFile("temp.txt");
        int id;
        string name;
        double balance;
    
        // Copy the contents of the original file to a temporary file
        while (userFile >> id >> name >> balance) {
            if (id == userId) {
                balance = newBalance;  // Update the balance for the specific member
            }
            tempFile << id << " " << name << " " << balance << endl;
        }
    
        userFile.close();
        tempFile.close();
    
        // Rename the temporary file back to the original file
        remove((fundName + "_users.txt").c_str());
        rename("temp.txt", (fundName + "_users.txt").c_str());
    }
    
    

    bool hasCollectedContributions() {
        ifstream userFile(fundName + "_users.txt");
        int id;
        string name;
        double balance;
        bool allContributed = true;

        while (userFile >> id >> name >> balance) {
            if (balance == 0) {
                allContributed = false;  // If a member has not contributed, stop and return false
                break;
            }
        }
        userFile.close();
        return allContributed;
    }

    void distributeFunds() {
        if (members == nullptr) {
            cout << "No members in the fund to distribute the funds!" << endl;
            return;
        }

        // Randomly select a winner
        srand(time(0));
        
        Member* temp = members;
        int numMembers = 0;
        while (temp) {
            numMembers++;
            temp = temp->next;
        }

        // If no members in the fund, return
        if (numMembers == 0) {
            cout << "No members available to distribute funds!" << endl;
            return;
        }

        // Generate a random winner index
        int winnerIndex = rand() % numMembers;

        // Find the winner
        temp = members;
        int index = 0;
        while (temp) {
            if (index == winnerIndex) {
                cout << "The winner for cycle " << currentCycle << " is: " << temp->name << endl;
                break;
            }
            temp = temp->next;
            index++;
        }

        cout << "Funds distributed to " << temp->name << "!" << endl;
    }
};

int main() {
    srand(time(0));
    ChitFund chitFund;
    int choice;
    string fundName;
    
    cout << "1. Create New Fund\n2. Load Existing Fund\nEnter choice: ";
    cin >> choice;
    
    if (choice == 1) {
        chitFund.createNewFund();
    } else {
        cout << "Enter fund name: ";
        cin >> fundName;
        if (!chitFund.loadFund(fundName)) return 0;
    }

    do {
        cout << "\n===== Chit Fund Menu =====\n";
        cout << "1. Add Member\n2. Collect Contributions\n3. Distribute Funds\n4. Exit\nEnter choice: ";
        cin >> choice;
        if (choice == 1) chitFund.addMember();
        else if (choice == 2) chitFund.collectContributions();
        else if (choice == 3) chitFund.distributeFunds();
    } while (choice != 4);
    
    return 0;
}
