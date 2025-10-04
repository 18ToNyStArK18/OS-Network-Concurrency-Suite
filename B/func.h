#ifndef FUNC_H
#define FUNC_H
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
#include <netinet/if_ether.h>
#include <time.h>
#include <ctype.h> 
#include <stdbool.h>
#include <signal.h>
#define MAX_PACKETS 10000
void pckt_handler(u_char *user_data, const struct pcap_pkthdr *pkthdr, const u_char *packet);
void Sniffing(pcap_if_t *dev);
void print_mac_address(const u_char *mac_addr);
void IPv4(const u_char *packet);
void IPv6(const u_char *packet);
void ARP(const u_char *packet);
const char* get_port_name(uint16_t port);
void UDP(const u_char *packet,int ip_payload_len);
void TCP(const u_char *packet,int ip_payload_len);
void Detailed_analysis(int req);
extern char filter[7];
typedef struct data{
	u_char * packet;
	struct pcap_pkthdr hdr;
}data;
void print_packet_summary(int packet_id, const data* packet_info);
extern data my_data[MAX_PACKETS+1];
extern long p_index;
#endif
