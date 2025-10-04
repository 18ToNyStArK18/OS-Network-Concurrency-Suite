// need to implement the signal handlers
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pcap.h>
#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <netinet/ip_icmp.h>
#include <net/if_arp.h>
#include <arpa/inet.h>
#include <time.h>
#include "func.h"
char filter[7];
data my_data[MAX_PACKETS+1];
int main(){
    
	int running = 1;
	while(running){
		printf("[C-Shark] The Command-Line Packet Predator\n");
		printf("==============================================\n");
		printf("[C-Shark] Searching for available interfaces...");
		// logic for the finding all the available network interfaces
		pcap_if_t *interfaces;
		pcap_if_t *selected;
		char buff[PCAP_ERRBUF_SIZE];
		int count = 0;
		pcap_if_t *it;
		int user_inp=-1;

		if(pcap_findalldevs(&interfaces,buff)==-1){
			fprintf(stderr,"\nError finding all the interfaces\n");
			continue;
		}
		printf("Found |\n\n");

		for( it = interfaces ; it != NULL ; it = it->next ){
			count++;
			printf("%d %s",count,it->name);
			if(it->description)
				printf(" (%s)\n",it->description);
			else
				printf("\n");
		}
		if(count == 0){
			printf("No interfaces found\n");
			continue;
		}
		printf("\nSelect an interface to sniff (1-%d): ",count);
		scanf("%d",&user_inp);
		if(user_inp < 1 && user_inp > count){
			printf("Invalid selection\n");
			continue;
		}
		it = interfaces;
		for(int i=0;i<user_inp-1;i++)
			it = it->next;
		selected = it;
		printf("\nInterface '%s' selected. What's next?\n\n",selected->name);
		printf("1. Start Sniffing (All Packets)\n2. Start Sniffing (With Filters)\n3. Inspect Last Session\n4. Exit C-Shark");
		printf("\nEnter the number: ");
		scanf("%d",&user_inp);
		if(user_inp == 4){
			running = 0;
			continue;
		}
		else if(user_inp == 1){
            strcpy(filter,"111111");
			Sniffing(selected);
		}
        else if(user_inp == 2){
            printf("Enter the number in binary bits corresponding whether you need that protocol or not \n the order of the bits are HTTP HTTPS DNS ARP TCP UDP");
            printf("\n Your Input: ");
            scanf("%s",filter);
            Sniffing(selected);
        }
        else if(user_inp == 3){
            int i = 0;
            while(i <= p_index){
                print_packet_summary(i+1,&my_data[i]);
                i++;
            }
            int req;
            printf("Enter the input for which you want detailed analysis: ");
            scanf("%d",&req);
            Detailed_analysis(req);
        }
        else {
            printf("Invalid Input\n");
        }
	}



}
