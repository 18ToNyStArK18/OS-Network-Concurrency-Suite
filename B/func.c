#include "func.h"
pcap_t *pcap_handle_g;
long p_index;
void print_mac_address(const u_char *mac_addr) {
	for (int i = 0; i < ETH_ALEN; i++) {
		printf("%02x", mac_addr[i]);
		if (i < ETH_ALEN - 1) {
			printf(":");
		}
	}
}
void signal_handler(int signum) {
    if (signum == SIGINT) {
        printf("\n[C-Shark] Interrupt signal received. Stopping capture...\n");
        if (pcap_handle_g != NULL) {
            pcap_breakloop(pcap_handle_g);
        }
    }
}
const char* get_port_name(uint16_t port) {
	switch (port) {
		case 80: return " (HTTP)";
		case 443: return " (HTTPS)";
		case 53: return " (DNS)";
		case 21: return " (FTP)";
		case 22: return " (SSH)";
		case 25: return " (SMTP)";
		default: return "";
	}
}
const char* get_app_protocol_name(uint16_t port) {
    switch (port) {
        case 80: return "HTTP";
        case 443: return "HTTPS/TLS";
        case 53: return "DNS";
        default: return "Data"; // Default for unknown common ports
    }
}
//llm code begins
void print_packet_summary(int packet_id, const data* packet_info) {
    char ip_src_str[INET6_ADDRSTRLEN];
    char ip_dst_str[INET6_ADDRSTRLEN];
    char final_src[INET6_ADDRSTRLEN + 8]; // Space for IP and port
    char final_dst[INET6_ADDRSTRLEN + 8];
    char l3_proto[10] = "Unknown";
    char l4_proto[10] = "N/A";

    // Set defaults
    strcpy(ip_src_str, "N/A");
    strcpy(ip_dst_str, "N/A");

    const struct ether_header *eth_header = (const struct ether_header *)packet_info->packet;
    uint16_t ether_type = ntohs(eth_header->ether_type);
    const u_char *l3_packet = packet_info->packet + sizeof(struct ether_header);

    if (ether_type == ETHERTYPE_IP) {
        strcpy(l3_proto, "IPv4");
        const struct ip *ip_header = (const struct ip *)l3_packet;
        inet_ntop(AF_INET, &ip_header->ip_src, ip_src_str, sizeof(ip_src_str));
        inet_ntop(AF_INET, &ip_header->ip_dst, ip_dst_str, sizeof(ip_dst_str));

        // Start with the IP address
        snprintf(final_src, sizeof(final_src), "%s", ip_src_str);
        snprintf(final_dst, sizeof(final_dst), "%s", ip_dst_str);

        const u_char *l4_packet = l3_packet + (ip_header->ip_hl * 4);
        if (ip_header->ip_p == IPPROTO_TCP) {
            strcpy(l4_proto, "TCP");
            const struct tcphdr *tcp_header = (const struct tcphdr *)l4_packet;
            // Append the port safely
            snprintf(final_src, sizeof(final_src), "%s:%d", ip_src_str, ntohs(tcp_header->th_sport));
            snprintf(final_dst, sizeof(final_dst), "%s:%d", ip_dst_str, ntohs(tcp_header->th_dport));
        } else if (ip_header->ip_p == IPPROTO_UDP) {
            strcpy(l4_proto, "UDP");
            const struct udphdr *udp_header = (const struct udphdr *)l4_packet;
            // Append the port safely
            snprintf(final_src, sizeof(final_src), "%s:%d", ip_src_str, ntohs(udp_header->uh_sport));
            snprintf(final_dst, sizeof(final_dst), "%s:%d", ip_dst_str, ntohs(udp_header->uh_dport));
        }
    } else if (ether_type == ETHERTYPE_ARP) {
        strcpy(l3_proto, "ARP");
        const struct ether_arp *arp_header = (const struct ether_arp *)l3_packet;
        inet_ntop(AF_INET, arp_header->arp_spa, final_src, sizeof(final_src));
        inet_ntop(AF_INET, arp_header->arp_tpa, final_dst, sizeof(final_dst));
    } else if (ether_type == ETHERTYPE_IPV6) {
        strcpy(l3_proto, "IPv6");
        // (IPv6 summary logic would go here, using snprintf for safety)
        strcpy(final_src, "IPv6_Src");
        strcpy(final_dst, "IPv6_Dst");
    }

    printf("  #%-4d | %ld.%06ld | %-7s | %-5s | %-22s -> %-22s\n",
           packet_id,
           packet_info->hdr.ts.tv_sec, packet_info->hdr.ts.tv_usec,
           l3_proto, l4_proto,
           final_src, final_dst);
}
// llm code ends
void handle_payload(const u_char *payload, int len) {
    if (len <= 0) return;

    const int bytes_per_line = 16;
    char ascii[bytes_per_line + 1];
    
    int len_to_print = len > 64 ? 64 : len;

    printf("Data (first %d bytes):\n", len_to_print);

    for (int i = 0; i < len_to_print; i++) {
        if (i % bytes_per_line == 0) {
            printf("              ");
        }
        printf("%02x ", payload[i]);

        if (isprint(payload[i])) {
            ascii[i % bytes_per_line] = payload[i];
        } else {
            ascii[i % bytes_per_line] = '.';
        }

        if ((i + 1) % bytes_per_line == 0 || i == len_to_print - 1) {
            ascii[(i % bytes_per_line) + 1] = '\0';
            
			for (int j = (i % bytes_per_line) + 1; j < bytes_per_line; j++) {
				printf("   ");
			}
			printf("%s\n", ascii);
		}
	}
}

void UDP(const u_char *packet,int ip_payload_len) {
	const struct udphdr *udp_header = (const struct udphdr *)packet;
	uint16_t src_port = ntohs(udp_header->uh_sport);
	uint16_t dst_port = ntohs(udp_header->uh_dport);
    printf("UDP HEADER (Layer 4)\n");
    printf("--------------------\n");
	printf("Src Port: %d%s | Dst Port: %d%s | Length: %d | Checksum: 0x%04X\n",
			src_port, get_port_name(src_port),
			dst_port, get_port_name(dst_port),
			ntohs(udp_header->uh_ulen),
			ntohs(udp_header->uh_sum));
	int payload_len = ip_payload_len - 8;
	const u_char *payload = packet + 8;
	const char *app_proto = get_app_protocol_name(dst_port);
	printf("L7 (Payload): Identified as %s on port %d - %d bytes\n", app_proto, dst_port, payload_len);
	handle_payload(payload, payload_len);
}
void TCP(const u_char *packet,int ip_payload_len) {
	const struct tcphdr *tcp_header = (const struct tcphdr *)packet;
	uint16_t src_port = ntohs(tcp_header->th_sport);
	uint16_t dst_port = ntohs(tcp_header->th_dport);
	uint tcp_header_len = tcp_header->th_off * 4;
    printf("TCP HEADER (Layer 4)\n");
    printf("--------------------\n");
	printf("Src Port: %d%s | Dst Port: %d%s | Seq: %u | Ack: %u\n",
			src_port, get_port_name(src_port),
			dst_port, get_port_name(dst_port),
			ntohl(tcp_header->th_seq),
			ntohl(tcp_header->th_ack));

	char flags_str[40] = {0};
	if (tcp_header->th_flags & TH_SYN) strcat(flags_str, "SYN, ");
	if (tcp_header->th_flags & TH_ACK) strcat(flags_str, "ACK, ");
	if (tcp_header->th_flags & TH_FIN) strcat(flags_str, "FIN, ");
	if (tcp_header->th_flags & TH_RST) strcat(flags_str, "RST, ");
	if (tcp_header->th_flags & TH_PUSH) strcat(flags_str, "PUSH, ");
	if (tcp_header->th_flags & TH_URG) strcat(flags_str, "URG, ");

	if (strlen(flags_str) > 0) {
		flags_str[strlen(flags_str) - 2] = '\0';
	}

	printf("Flags: [%s] | Window: %d | Checksum: 0x%04X | Header Length: %d bytes\n",
			flags_str,
			ntohs(tcp_header->th_win),
			ntohs(tcp_header->th_sum),
			tcp_header->th_off * 4);
	int payload_len = ip_payload_len - tcp_header_len;
	const u_char *payload = packet + tcp_header_len;
	const char *app_proto = get_app_protocol_name(dst_port);
	printf("L7 (Payload): Identified as %s on port %d - %d bytes\n", app_proto, dst_port, payload_len);
	handle_payload(payload, payload_len);
}
void IPv4(const u_char *packet){
	printf("\nIPv4 HEADER (Layer 3)\n");
    printf("-----------------------\n");
	const struct  ip *ip_header = (const struct ip*)packet;
	char src[INET_ADDRSTRLEN];
	char dst[INET_ADDRSTRLEN];

	// from binary to readable format

	inet_ntop(AF_INET, &(ip_header->ip_src),src,INET_ADDRSTRLEN);
	inet_ntop(AF_INET, &(ip_header->ip_dst),dst,INET_ADDRSTRLEN);

	printf(" Src IP: %s | Dst IP: %s | Protocol: ",src,dst);
	if(ip_header->ip_p == IPPROTO_TCP)
		printf("TCP (%d)",IPPROTO_TCP);
	else if(ip_header->ip_p == IPPROTO_UDP)
		printf("UDP (%d)",IPPROTO_UDP);
	else if(ip_header->ip_p == IPPROTO_ICMP)
		printf("ICMP (%d)",IPPROTO_ICMP);
	printf(" | TTL: %d\nID: 0x%04X | Total Length: %d | Header Length: %d bytes | ",ip_header->ip_ttl,ntohs(ip_header->ip_id),ntohs(ip_header->ip_len),ip_header->ip_hl * 4);
	uint16_t flags = ntohs(ip_header->ip_off);
	int df_flag = (flags & IP_DF) ? 1 : 0; 
	int mf_flag = (flags & IP_MF) ? 1 : 0; 
	printf("Flags: DF: %d MF: %d\n",df_flag,mf_flag);
	uint ip_header_len = ip_header->ip_hl * 4;
	const u_char *l4_packet = packet + ip_header_len;
	int ip_payload_len = ntohs(ip_header->ip_len) - ip_header_len;
	if(ip_header->ip_p == IPPROTO_TCP)
		TCP(l4_packet,ip_payload_len);
	else if(ip_header->ip_p == IPPROTO_UDP)
		UDP(l4_packet,ip_payload_len);
	return;
}
void IPv6(const u_char *packet){
    printf("\nIPv6 HEADER (Layer 3) \n");
    printf("-----------------------\n");
	const struct  ip6_hdr *ip_header = (const struct ip6_hdr *)packet;
	char src[INET6_ADDRSTRLEN];
	char dst[INET6_ADDRSTRLEN];

	// from binary to readable format

	inet_ntop(AF_INET6, &(ip_header->ip6_src),src,INET6_ADDRSTRLEN);
	inet_ntop(AF_INET6, &(ip_header->ip6_dst),dst,INET6_ADDRSTRLEN);

	printf(" Src IP: %s | Dst IP: %s\nNext header: ",src,dst);
	if(ip_header->ip6_nxt == IPPROTO_TCP)
		printf("TCP (%d)",IPPROTO_TCP);
	else if(ip_header->ip6_nxt == IPPROTO_UDP)
		printf("UDP (%d)",IPPROTO_UDP);
	printf(" | ");
	uint32_t flow = ntohl(ip_header->ip6_flow);
	uint8_t val = flow>>20;
	uint32_t label = flow & 0x000FFFFF;
	printf("Hop Limit: %d | Traffic Class: 0x%02x | Flow Label: 0x%05x | Payload Length: %d\n",ip_header->ip6_hlim,val,label,ntohs(ip_header->ip6_plen));
	int ip_payload_len = ntohs(ip_header->ip6_plen);
	const u_char *l4_packet = packet + 40;
	if(ip_header->ip6_nxt == IPPROTO_TCP)
		TCP(l4_packet,ip_payload_len);
	else if(ip_header->ip6_nxt == IPPROTO_UDP)
		UDP(l4_packet,ip_payload_len);
	return;
}
void ARP(const u_char *packet) {
	const struct ether_arp *arp_header = (const struct ether_arp *)packet;
	char sender_ip[INET_ADDRSTRLEN];
	char target_ip[INET_ADDRSTRLEN];

	inet_ntop(AF_INET, arp_header->arp_spa, sender_ip, INET_ADDRSTRLEN);
	inet_ntop(AF_INET, arp_header->arp_tpa, target_ip, INET_ADDRSTRLEN);
    printf("\nARP HEADER (Layer 3)\n");
    printf("--------------------\n");
	printf("Operation: ");
	switch (ntohs(arp_header->ea_hdr.ar_op)) {
		case ARPOP_REQUEST: printf("Request (1)"); break;
		case ARPOP_REPLY:   printf("Reply (2)"); break;
		default:            printf("Unknown (%d)", ntohs(arp_header->ea_hdr.ar_op)); break;
	}
	printf(" | Sender IP: %s", sender_ip);
	printf(" | Target IP: %s\n", target_ip);
	printf("Sender MAC: ");
	print_mac_address(arp_header->arp_sha);
	printf(" | Target MAC: ");
	print_mac_address(arp_header->arp_tha);
	printf("\n");
	printf("HW Type: %d | Proto Type: 0x%04x | HW Len: %d | Proto Len: %d\n", 
			ntohs(arp_header->ea_hdr.ar_hrd),ntohs(arp_header->ea_hdr.ar_pro) ,
			arp_header->ea_hdr.ar_hln,arp_header->ea_hdr.ar_pln);

}

void pckt_handler(u_char *user_data, const struct pcap_pkthdr *pkthdr, const u_char *packet){
    //filter logic
    long *id = (long *)user_data;
    p_index = *id;
    bool is_arp = false , is_tcp = false , is_udp = false;
    bool print_packet = false;
    uint16_t src = 0, dst = 0;
    const struct ether_header *ether_hdr = (struct ether_header *)packet;
    uint16_t ether = ntohs(ether_hdr->ether_type);
    
    //storing the Data
    if(*id < MAX_PACKETS){
        my_data[*id].packet = malloc(pkthdr->caplen);
        memcpy(my_data[*id].packet, packet, pkthdr->caplen);
        my_data[*id].hdr = *pkthdr;
    }
    //storing Data ends
    if(ether == ETHERTYPE_ARP)
        is_arp = true;
    else if (ether == ETHERTYPE_IP){
        const struct ip * ip_hdr = (struct ip *)(packet + sizeof(struct ether_header));
        uint ip_len = ip_hdr->ip_hl * 4;
        const u_char * l4_packet = packet + sizeof(struct ether_header) + ip_len;

        if(ip_hdr->ip_p == IPPROTO_TCP){
            is_tcp = true;
            const struct tcphdr * tcp_hdr = (const struct tcphdr *)l4_packet;
            src = ntohs(tcp_hdr->th_sport);
            dst = ntohs(tcp_hdr->th_dport);
        }
        else if(ip_hdr->ip_p == IPPROTO_UDP){
            is_udp = true;
            const struct udphdr * udp_hdr = (const struct udphdr *)l4_packet;
            src = ntohs(udp_hdr->uh_sport);
            dst = ntohs(udp_hdr->uh_dport);

        }
    }
    else if(ether ==  ETHERTYPE_IPV6){
        const struct ip6_hdr *ip6 = (struct ip6_hdr *)(packet + sizeof(struct ether_header));
        const u_char *l4_packet = packet + sizeof(struct ether_header) + 40;

        if(ip6->ip6_nxt == IPPROTO_TCP){
            is_tcp = true;
            const struct tcphdr * hd = (struct tcphdr *)l4_packet;
            src = ntohs(hd->th_sport);
            dst = ntohs(hd->th_dport);
        }
        else if(ip6->ip6_nxt == IPPROTO_UDP){
            is_udp = true;
            const struct udphdr * hd = (struct udphdr *)l4_packet;
            src = ntohs(hd->uh_sport);
            dst = ntohs(hd->uh_dport);
        }
    }
    int flag = 1;
    for(int i =0;i < 6; i++){
        if(filter[0] == '0')
            flag =0;
    }
    if(flag)
        print_packet = true;
    if (filter[0] == '1' && is_tcp && (src == 80 || dst == 80)) print_packet = true;
    if (filter[1] == '1' && is_tcp && (src == 443 || dst == 443)) print_packet = true;
    if (filter[2] == '1' && (src == 53 || dst == 53)) print_packet = true;
    if (filter[3] == '1' && is_arp) print_packet = true;
    if (filter[4] == '1' && is_tcp) print_packet = true;
    if (filter[5] == '1' && is_udp) print_packet = true;
    if(!print_packet)
        return;
    (*id)++;
    printf("---------------------------------------------------------\n");
    printf("\nPacket #%ld | ",*id);
    printf("Timestamp: %ld.%06ld | ",pkthdr->ts.tv_sec, pkthdr->ts.tv_usec);
    printf("Length: %d bytes\n",pkthdr->caplen);
    printf("First 16 raw bytes: ");
    int num_of_bytes = pkthdr->caplen;
    if(num_of_bytes > 16)
        num_of_bytes = 16;
    for (int i = 0; i < num_of_bytes; i++) {
        printf("%02x ", packet[i]);
        // just adding a space after 8 bytes to make it look good
        if ((i + 1) % 8 == 0 && (i + 1) != num_of_bytes) {
            printf(" ");
        }
    }
    printf("\n");
    // Layer 2 decoding
    const struct ether_header *header = (const struct ether_header *)packet;
    printf("L2 (Ethernet): Dst MAC: ");
    for (int i = 0; i < ETH_ALEN; i++) {
        printf("%02x", header->ether_dhost[i]);
        if (i < ETH_ALEN - 1) {
            printf(":");
        }
    }
    printf(" | Src MAC: ");
    for (int i = 0; i < ETH_ALEN; i++) {
        printf("%02x", header->ether_shost[i]);
        if (i < ETH_ALEN - 1) {
            printf(":");
        }
    }
    const u_char *l3_packet = packet + sizeof(struct ether_header);
    printf(" | EtherType: ");
    uint16_t ether_2 = ntohs(header->ether_type);
    if(ether_2 == ETHERTYPE_IP){
        printf("IPv4 (0x%04x)",ether_2);
        IPv4(l3_packet);
    }
    else if(ether_2 == ETHERTYPE_IPV6){
        printf("IPv6 (0x%04x)",ether_2);
        IPv6(l3_packet);
    }
    else if(ether_2 == ETHERTYPE_ARP){
        printf("ARP (0x%04x)",ether_2);
        ARP(l3_packet);
    }
    else
        printf("Unknown Type (0x%04x)",ether_2);
    printf("\n");
}
void Sniffing(pcap_if_t *dev){
    signal(SIGINT, signal_handler);
    printf("[C-Shark] Preparing to sniff all the packets from interface: %s \n",dev->name);
    char err[PCAP_ERRBUF_SIZE];
    long packet_id = 0;
    pcap_handle_g = pcap_open_live(dev->name, BUFSIZ, 1, 1000, err);
    if(!pcap_handle_g)
        return;
    printf("Starting packet capture...\n");
    pcap_loop(pcap_handle_g,-1,pckt_handler,(u_char *)&packet_id);
    pcap_close(pcap_handle_g);
    return;
}
// printing detailed analysis
void CompleteFrame(const u_char* Packet , int len){
    if(len <= 0)
        return;
    int per_line = 16;
    char ascii[per_line+1];
    printf("\n--- COMPLETE FRAME HEX DUMP (%d bytes) ---\n", len);
    printf("Offset(h) 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F   ASCII\n");
    printf("----------------------------------------------------------------------\n");
    for (int i = 0; i < len; i++) {
        if (i % per_line == 0) {
            printf("%08x: ", i);
        }
        printf("%02x ", Packet[i]);
        if (i % per_line == 7) {
            printf(" ");
        }

        ascii[i % per_line] = isprint(Packet[i]) ? Packet[i] : '.';

        if ((i + 1) % per_line == 0 || i == len - 1) {
            ascii[(i % per_line) + 1] = '\0';

            if (i == len - 1) {
                for (int j = (i % per_line) + 1; j < per_line; j++) {
                    printf("   "); 
                    if (j == 7) printf(" "); 
                }
            }
            printf(" |%s|\n", ascii);
        }
    }
}

void Print_Ethernet(u_char* packet){
    printf("ETHERNET II FRAME (Layer 2)\n");
    printf("---------------------------\n");
    const struct ether_header *eth_hdr = (const struct ether_header *)packet;
    char mac_str[20];
    snprintf(mac_str,sizeof(mac_str),"%02x:%02x:%02x:%02x:%02x:%02x",eth_hdr->ether_dhost[0],eth_hdr->ether_dhost[1],eth_hdr->ether_dhost[2],eth_hdr->ether_dhost[3],eth_hdr->ether_dhost[4],eth_hdr->ether_dhost[5]);
    printf("   Destination MAC: %s (Bytes 0-5)\n", mac_str);
    snprintf(mac_str,sizeof(mac_str),"%02x %02x %02x %02x %02x %02x",eth_hdr->ether_dhost[0],eth_hdr->ether_dhost[1],eth_hdr->ether_dhost[2],eth_hdr->ether_dhost[3],eth_hdr->ether_dhost[4],eth_hdr->ether_dhost[5]);
    printf("   └─ Hex: %s\n",mac_str);
    snprintf(mac_str,sizeof(mac_str),"%02x:%02x:%02x:%02x:%02x:%02x",eth_hdr->ether_shost[0],eth_hdr->ether_shost[1],eth_hdr->ether_shost[2],eth_hdr->ether_shost[3],eth_hdr->ether_shost[4],eth_hdr->ether_shost[5]);
    printf("   Source MAC: %s (Bytes 6-11)\n", mac_str);
    snprintf(mac_str,sizeof(mac_str),"%02x %02x %02x %02x %02x %02x",eth_hdr->ether_shost[0],eth_hdr->ether_shost[1],eth_hdr->ether_shost[2],eth_hdr->ether_shost[3],eth_hdr->ether_shost[4],eth_hdr->ether_shost[5]);
    printf("   └─ Hex: %s\n",mac_str);
    int types = ntohs(eth_hdr->ether_type);
    const u_char* l3_packet = packet+sizeof(struct ether_header);
    if(types == ETHERTYPE_IP){
        printf("   EtherType: 0x%04X (IPv4)(Bytes 12-13)\n", ntohs(eth_hdr->ether_type));
        IPv4(l3_packet);
    }
    else if(types == ETHERTYPE_IPV6){
        printf("   EtherType: 0x%04X (IPv6)(Bytes 12-13)\n", ntohs(eth_hdr->ether_type));
        IPv6(l3_packet);
    }
    else if(types == ETHERTYPE_ARP){
        printf("   EtherType: 0x%04X (ARP)(Bytes 12-13)\n", ntohs(eth_hdr->ether_type));
        ARP(l3_packet);
    }
    else{
        printf("Unknown Type\n");
    }
    return;

}
void Detailed_analysis(int req){
    if(req >  p_index + 1){
        printf("Invalid Input\n");
        return;
    }
    data *Request = &my_data[req-1];

    printf("C-SHARK DETAILED PACKET ANALYSIS\n");
    printf("--------------------------------\n");
    printf("PACKET SUMMARY\n");
    printf("--------------\n");
    printf("Packet ID:\t#%d\nTimestamp:\t%ld.%06ld\nFrame Length:\t%d\nCaptured:\t%d\n",req,Request->hdr.ts.tv_sec,Request->hdr.ts.tv_usec,Request->hdr.caplen,Request->hdr.caplen);
    CompleteFrame(Request->packet,Request->hdr.caplen); // COMPLETE FRAME HEX DUMP;
    printf("LAYER-BY_LAYER ANALYSIS\n");
    printf("-----------------------\n");
    Print_Ethernet(Request->packet);


}
