#include <iostream>
using namespace std;

const int MAX_SIZE = 100;
int function_calls = 0;

int CheckSumPossibility(int num, int arr[], int size);

int main(){
    int arraySize;
    int arr[MAX_SIZE];
    int num;
    int returnVal;
    
    cout << "Please enter the array size: " << endl;
    cin >> arraySize;
    
    cout << "Please enter the target number: " << endl;
    cin >> num;
    
    for(int i=0;i<arraySize;++i){
        cout << "Please enter elements of the array: " << endl;
        cin >> arr[i];
    }
    
    returnVal = CheckSumPossibility(num,arr,arraySize);

    if(returnVal == 1){
        cout << "\nPossible!\n";
    } else {
        cout << "\nNot Possible!\n";
    }

    cout << "Number of function calls: " << function_calls << endl;

    return 0;
}

int CheckSumPossibility(int num, int arr[], int size){
    if(size == 0)
        return 0;
    if(num < 0)
        return 0;
    if(num == 0)
        return 1;

    function_calls++;

    int newSize = size - 1;
    int newNumber = num-arr[size-1];
    int x = CheckSumPossibility(newNumber,arr,newSize);
    if(x == 1){
        return 1;
    }

    newSize = size - 1;
    int y = CheckSumPossibility(num,arr,newSize);
    if(y == 1){
        return 1;
    }

    return x || y;
}