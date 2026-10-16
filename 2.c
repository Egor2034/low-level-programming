#include "stdio.h"

#define MAX_SIZE 100

int arr[MAX_SIZE];

int main() {
    int n;
    int i;
    int left;
    int right;
    int swapped;
    int temp;

    printf("Enter count of elements: ");
    scanf("%d", &n);

    printf("Enter numbers:\n");
    i = 0;

read_loop_start:
    if (i >= n) goto read_loop_end;
    scanf("%d", &arr[i]);
    i = i + 1;
    goto read_loop_start;

read_loop_end:
    left = 0;
    right = n;
    right = n - 1;
    swapped = 1;

while_start:
    if (swapped == 0) goto while_end;
    swapped = 0;
    i = left;

forward_start:
    if (i >= right) goto forward_end;
    
    if (arr[i] <= arr[i + 1]) goto forward_no_swap;
    temp = arr[i];
    arr[i] = arr[i + 1];
    arr[i + 1] = temp;
    swapped = 1;

forward_no_swap:
    i = i + 1;
    goto forward_start;

    forward_end:

    if (swapped == 0) goto while_end;
    
    swapped = 0;
    right = right - 1;
    i = right;
    
backward_start:
    if (i <= left) goto backward_end;
    
    if (arr[i] >= arr[i - 1]) goto backward_no_swap;
    temp = arr[i];
    arr[i] = arr[i - 1];
    arr[i - 1] = temp;
    swapped = 1;

backward_no_swap:
    i = i - 1;
    goto backward_start;

backward_end:
    left = left + 1;
    goto while_start;

while_end:
    printf("Sorted array:\n");
    i = 0;

print_loop_start:
    if (i >= n) goto print_loop_end;
    printf("%d ", arr[i]);
    i = i + 1;
    goto print_loop_start;

print_loop_end:
    printf("\n");

    return 0;
}