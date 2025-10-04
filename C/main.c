#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/types.h>
#include <unistd.h>
#include <semaphore.h>
#include <string.h>
#include <time.h>
// has four ovens and four chefs and max customers is 25 and if the customers count is more than 25 he will enter the bakery
// sits on sofa or stands if the sofa is occupied 
// chef will give the cake to the person who sat on the sofa for the longest time
// if a sofa is free then the person who is standing for the longest will sits
// for the payment any chef can accept but there is only one cash register so one payment at a time
// chefs only handle both the payment and baking and learning new recipies(when there is no customer waiting)?? 
// customers on arrival will do the following enter -> sit -> getcake -> payment
// chef bake and payment and payment has more priority than the baking part
// if the count is more than the capacity the person cannot enter and 
// customers getcake and the chefs baking should execute concurrently 
// person should pay before the chef can call accept payment
// chef should accept payment before the customers leave and the chefs are unique with ids 1,2,3,4
// every action of the customer takes one second and the baking and the payment each takes 2 seconds
// once a person sits on a sofa then he sits until he leaves
// four persons can sit on sofa
// once a action is started it cant be stopped until its over
//
// plan:
//      create 4 threads for the chefs so that they can work independently
//      each person is also an independent so i can create a thread 
//      i store a counter which indicates number of people currenly in the bakery if it is 25 the next customer leaves
//      one var indicating no of sofa seats left
//      one var indicates no of chefs available
//      i need to wait for one second for every thing other than baking and payment for this 2 seconds
//      first a customer will come if seat is empty he will sit and wait until a chef is free if any chef is free the chef starts baking it will take 2 seconds  and for the payment 2 more seconds
//      for the first person of the day 1 sec to enter 1 sec to sit 2 sec to bake and 2 sec for the payment and one sec to leave so its 7 seconds
//      problem how do i find the number of the chefs left and no of sofas left
pthread_mutex_t cash_register_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t sofa_access_lock = PTHREAD_MUTEX_INITIALIZER;

sem_t num_of_chefs;
sem_t num_of_cus;

typedef struct{
    long arrival_time;
    long customer_id;
    int is_siting;
    int is_baking;
    int is_paying;
} event;

#define QUEUE_MAX 25
#define CUS_MAX 1000
#define SOFA_SEATS 4
#define BAKERY_CAPACITY 25
#define NUM_CHEFS 4


typedef struct{
    event *data[QUEUE_MAX];
    int head;
    int tail;
    int count;
    pthread_mutex_t mutex;
} Queue;

Queue standing;
Queue sofa;
long init_time;

void my_init(Queue *q){
    q->head = 0;
    q->tail = 0;
    q->count = 0;
    pthread_mutex_init(&q->mutex, NULL);
}

int my_enqueue(Queue *q, event *current){
    pthread_mutex_lock(&q->mutex);
    if(q->count < QUEUE_MAX){
        q->data[q->tail] = current;
        q->tail = (q->tail + 1) % QUEUE_MAX;
        q->count++;
        pthread_mutex_unlock(&q->mutex);
        return 1;
    }
    pthread_mutex_unlock(&q->mutex);
    return -1;
}

event* my_dequeue(Queue *q) {
    pthread_mutex_lock(&q->mutex);
    event *item = NULL; 

    if (q->count > 0) {
        item = q->data[q->head];
        q->head = (q->head + 1) % QUEUE_MAX;
        q->count--;
    }
    pthread_mutex_unlock(&q->mutex);
    return item;
}

int get_count(Queue *q){
    int ans = 0;
    pthread_mutex_lock(&q->mutex);
    ans = q->count;
    pthread_mutex_unlock(&q->mutex);
    return ans;
}

void *Chef(void *args){
    int id = *(int*)args;
    while(1){
        event *current = my_dequeue(&sofa);

        if(current != NULL){ 
            printf("[%ld] Chef %d is baking for Customer %ld\n", time(NULL)-init_time,id,current->customer_id);
            sleep(2); //for baking
            current->is_baking = 1;
            printf("[%ld] Customer %ld got cake, ready to pay\n",time(NULL)-init_time,current->customer_id);
            pthread_mutex_lock(&cash_register_lock);
            sleep(2); // for payment
            pthread_mutex_unlock(&cash_register_lock);
            current->is_paying = 1;
            printf("[%ld] Customer %ld payment done, ready to leave\n",time(NULL)-init_time,current->customer_id);
            pthread_mutex_lock(&sofa_access_lock);
            event *standing_customer = my_dequeue(&standing);
            if(standing_customer != NULL){
                sleep(1); // to sit
                printf("[%ld] Customer %ld left\n",time(NULL)-init_time,current->customer_id);
                printf("[%ld] Customer %ld moves from standing to sofa\n",time(NULL)-init_time, standing_customer->customer_id);
                my_enqueue(&sofa, standing_customer);
            }
            else{
                sleep(1);// spends one second to leave
                printf("[%ld] Customer %ld left\n",time(NULL)-init_time,current->customer_id);
            }
            pthread_mutex_unlock(&sofa_access_lock);
        }
        
        // Prevents the chef from burning 100% CPU when the sofa is empty
        else 
        usleep(10000); 
    }
    return NULL;
}

void *customer(void *args){
    event *current = (event *)args;
    sleep(current->arrival_time+1);

    if(sem_trywait(&num_of_cus) != 0){
        printf("[%ld] Customer %ld leaves, bakery is full.\n", time(NULL)-init_time, current->customer_id);
        return NULL;
    }
    
    printf("[%ld] Customer %ld enters\n", time(NULL)-init_time, current->customer_id);
    sleep(1); // to enter

    pthread_mutex_lock(&sofa_access_lock);
    if(get_count(&sofa) < SOFA_SEATS){
        my_enqueue(&sofa,current);
        printf("[%ld] Customer %ld sits on the sofa\n",time(NULL)-init_time,current->customer_id);
    } else {
        my_enqueue(&standing,current);
        printf("[%ld] Customer %ld is standing\n",time(NULL)-init_time,current->customer_id);
    }
    pthread_mutex_unlock(&sofa_access_lock);

    while(current->is_baking == 0)
        sleep(1);
    
    while(current->is_paying == 0)
        sleep(1);
    
    sleep(1);
    sem_post(&num_of_cus); 

    free(current); 
    return NULL;
}

int main(){
    init_time = time(NULL);
    sem_init(&num_of_cus,0,BAKERY_CAPACITY);
    sem_init(&num_of_chefs,0,NUM_CHEFS);

    my_init(&standing);
    my_init(&sofa);
    
    char line[200];
    pthread_t chef_threads[4];
    for(long i=0; i<4; i++){
        int *a = (int *)malloc(sizeof(int));
        *a = i+1;
        pthread_create(&chef_threads[i], NULL, Chef, a);
    }
    
    pthread_t customer_threads[CUS_MAX];
    int i = 0;
    FILE *fp = fopen("input.txt","r");
    if (fp == NULL) {
        perror("Error opening input.txt");
        return 1;
    }

    while(fgets(line,sizeof(line),fp)){
        if (strncmp(line, "<EOF>", 5) == 0) break;
        long time, id;
        char keyword[20];
        sscanf(line,"%ld %s %ld",&time,keyword,&id);

        event *current = malloc(sizeof(event));
        current->customer_id = id;
        current->arrival_time = time;
        current->is_baking = 0;
        current->is_paying = 0;
        current->is_siting = 0;
        pthread_create(&customer_threads[i++],NULL,customer,current);
    }
    fclose(fp);

    for (int j = 0; j < i; j++) {
        pthread_join(customer_threads[j], NULL);
    }

    printf("All customers served. Bakery is closing.\n");
    exit(0);
}
