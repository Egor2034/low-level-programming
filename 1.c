#include "stdio.h"
#include "locale.h"

#define MAX_SIZE 100

int arr[MAX_SIZE];

int main() {
    setlocale(LC_ALL, ".UTF8");
    int n;
    
    printf("Введите количество элементов в массиве: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        printf("Введите %d-й элемент: ", i + 1);
        scanf("%d", &arr[i]);
    }
    
    printf("Исходный массив: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    int left = 0;
    int right = n - 1;
    int swapped = 1;

    while (swapped) {
        swapped = 0;

        for (int i = left; i < right; i++) {
            if (arr[i] > arr[i + 1]) {
                int temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
                swapped = 1;
            }
        }

        if (!swapped) break;

        swapped = 0; 
        right = right - 1;

        for (int i = right; i > left; i--) {
            if (arr[i - 1] > arr[i]) {
                int temp = arr[i - 1];
                arr[i - 1] = arr[i];
                arr[i] = temp;
                swapped = 1;
            }
        }

        left = left + 1;
    }

    printf("Отсортированный массив: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }

    return 0;
}