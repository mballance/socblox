/*
 * net_hdr.h
 *
 *  Created on: Jan 27, 2015
 *      Author: ballance
 */

#ifndef NET_HDR_H_
#define NET_HDR_H_
#include <stdint.h>

#define __swab16(x) \
        ((uint16_t)( \
                (((uint16_t)(x) & (uint16_t)0x00ffU) << 8) | \
                (((uint16_t)(x) & (uint16_t)0xff00U) >> 8) ))
#define __swab32(x) \
        ((uint32_t)( \
                (((uint32_t)(x) & (uint32_t)0x000000ffUL) << 24) | \
                (((uint32_t)(x) & (uint32_t)0x0000ff00UL) <<  8) | \
                (((uint32_t)(x) & (uint32_t)0x00ff0000UL) >>  8) | \
                (((uint32_t)(x) & (uint32_t)0xff000000UL) >> 24) ))

#define ntohs(s) __swab16(s)
#define ntohl(s) __swab32(s)
#define htons(s) __swab16(s)

typedef struct eth_hdr_s {
	uint8_t		et_dest[6];	/* Destination node		*/
	uint8_t		et_src[6];	/* Source node			*/
	uint16_t	et_protlen;	/* Protocol or length		*/
} eth_hdr_t;

typedef struct ip_udp_hdr_s {
	uint8_t		ip_hl_v;	/* header length and version	*/
	uint8_t		ip_tos;		/* type of service		*/
	uint16_t	ip_len;		/* total length			*/
	uint16_t	ip_id;		/* identification		*/
	uint16_t	ip_off;		/* fragment offset field	*/
	uint8_t		ip_ttl;		/* time to live			*/
	uint8_t		ip_p;		/* protocol			*/
	uint16_t	ip_sum;		/* checksum			*/
	uint32_t	ip_src;		/* Source IP address		*/
	uint32_t	ip_dst;		/* Destination IP address	*/
	uint16_t	udp_src;	/* UDP source port		*/
	uint16_t	udp_dst;	/* UDP destination port		*/
	uint16_t	udp_len;	/* Length of UDP packet		*/
	uint16_t	udp_xsum;	/* Checksum			*/
} ip_udp_hdr_t;

#define ARP_ETHER	    1		/* Ethernet  hardware address	*/
#define ARP_HLEN		6
#define ARP_PLEN	4
#define ARPOP_REQUEST    1		/* Request  to resolve  address	*/
#define ARPOP_REPLY	    2		/* Response to previous request	*/
#define RARPOP_REQUEST   3		/* Request  to resolve  address	*/
#define RARPOP_REPLY	    4		/* Response to previous request */
#define ar_sha		ar_data[0]
#define ar_spa		ar_data[ARP_HLEN]
#define ar_tha		ar_data[ARP_HLEN + ARP_PLEN]
#define ar_tpa		ar_data[ARP_HLEN + ARP_PLEN + ARP_HLEN]

typedef struct arp_hdr_s {
	uint16_t		ar_hrd;		/* Format of hardware address	*/
	uint16_t		ar_pro;		/* Format of protocol address	*/
	uint8_t			ar_hln;		/* Length of hardware address	*/
	uint8_t			ar_pln;		/* Length of protocol address	*/
	uint16_t		ar_op;		/* Operation			*/

	/*
	 * The remaining fields are variable in size, according to
	 * the sizes above, and are defined as appropriate for
	 * specific hardware/protocol combinations.
	 */
	uint8_t		ar_data[0];
} arp_hdr_t;

typedef struct arp_hdr_max_s {
	uint16_t		ar_hrd;		/* Format of hardware address	*/
	uint16_t		ar_pro;		/* Format of protocol address	*/
	uint8_t			ar_hln;		/* Length of hardware address	*/
	uint8_t			ar_pln;		/* Length of protocol address	*/
	uint16_t		ar_op;		/* Operation			*/

	/*
	 * The remaining fields are variable in size, according to
	 * the sizes above, and are defined as appropriate for
	 * specific hardware/protocol combinations.
	 */
	uint8_t		ar_data[20];
} arp_hdr_max_t;

#endif /* NET_HDR_H_ */
