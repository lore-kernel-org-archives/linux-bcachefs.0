Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F804137C2A;
	Mon,  9 Jun 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749478867; cv=fail; b=PPjn169tgi7+gSZlVp5OZI4WURIpGvbfy8Q/SsndtHsFcCNKLo+TPYZ6fGoVjV/RXo17ACY1bUbPstkiUH1/I3ZRvy6cdns+d0Zrk4W+xbNo/DCeiWppw9lVlnyCXvZELDcX7xmMAlqAtkn/4cwD/UDvT8+UCukOQPXDB/mAESc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749478867; c=relaxed/simple;
	bh=o2ysEczaKignDWoX+CLKoWy3mHP4ZS/xYWY0cArs560=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fnEg5FWJMoCOadneaxYFAnItJ2hif9GdX3nELysvkIPBoi1bLzwtSDWuoR5WuCTTKevLStkX4Fwsr11E16rAT8s4J9ydEhNzWoGIMaiXlvdODIDtWy2RfJRsBaNvbQLT1I9xE4/ZMD9zdkvbw5zXPxIpfZ62ThaRvabNWVtrTqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D6MsTD83; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D6MsTD83"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qo/K1aho24gU0Hsgsqlcdv6gtZXVSIVNwvUsA5nLsvTHSX/5VP+fS94Kb+rHclzs5DqK//w3Fp6Q+YXuYPNnd8/gZFhxVKXSaMtF8opnt/DriBMND2CBed/enj84LVPqGswr6vtE4q3iWxrojyePTWwgAYZ2vWyVf5sy+gh4iLl+YPNLkMvHc1t9TLbPWTvfDNRJhs1DC6c6FGZheATuuoug4GUVx6die1FbGHQkiqP7a63/AvFodp7G9UE4LcJAHKs9lfAdOAWjjiXzfnLcUTC6RCLlO2NvJjvamSNE97RLtJt7qH1qdF7gRzAHI69PW0SkxyvC7q/4KRRVPKaB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhOnFHjSiZ9HUUtpvShOFFS1zDIKvDSxjegg9/iChSE=;
 b=tes4sT3p32joK3RzLqYadV0BtUVES6gJekWkMqWSm14WwS3ubqYHqUY4S0llwS+81CyDpNSqiRDvTzkDBqaJKJtFehnHXtTzNap3lsM915z1CKWwTYbkpWFeHd4yu25NRwa6HnmosW5y+lP0SC5cwj4EhvzQZcHMgXe1i3E8Jyv2PVB2DYJoc4bS0693YSXnAD8dRJInAW4cNikf/qF6gEmV+rSUSYqEpdsD4wA/Cl/5YDRlKDNgBqjzkD/t8/moLOnzqj2PO0Awz/u6vFqndD870PGxTphvuxYI8+J6K9v7RXUuniaWFqSsZH4CaLsxn4n6v+vFbS+VRtuAGet5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhOnFHjSiZ9HUUtpvShOFFS1zDIKvDSxjegg9/iChSE=;
 b=D6MsTD83S/NjS22A6eNLN4tcpkFEfMmVAjGh/wx+LLyt442gOsqFV8rUJf5C3HMP56WuZVTIvSf9/oLOWB3yy2/s87NiTEsgpflfGRQAS0q/sHPkDg1ObsVYLnIa8+y59JHopFLf6WTQgw0sPRooQlrWi9wH7ZnsrGDCbWVT+VCyICFqRfNHVBRnVlWSmMH3YZA7XQ4iPhLyiywahDnI8aWx10bS/5iBrN6ukTDHUOABTRoT2ut1E2ULL9MN1SmdeEJeO+G4/YOXYpMAsgoLYbAR1+tkNCgApyJa/hAVB7i6T+vpop24x9jtrBOADUO7HQ3zeu23NVmZXmpQWYHriQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by PH0PR12MB8822.namprd12.prod.outlook.com (2603:10b6:510:28d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 14:21:02 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.8792.034; Mon, 9 Jun 2025
 14:21:02 +0000
Message-ID: <2f762834-d143-4b84-9ab2-8bff4688ae66@nvidia.com>
Date: Mon, 9 Jun 2025 10:20:58 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
To: paulmck@kernel.org, Uladzislau Rezki <urezki@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, josh@joshtriplett.org,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
 <aEXVKNVLI3VQInSc@pc636>
 <602bb1be-f4a4-4194-803f-856e95711870@paulmck-laptop>
 <aEac1veMLffwOdv8@pc636>
 <e3187e7a-cac2-46c4-9c56-3a649e122353@paulmck-laptop>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <e3187e7a-cac2-46c4-9c56-3a649e122353@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0157.namprd03.prod.outlook.com
 (2603:10b6:a03:338::12) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|PH0PR12MB8822:EE_
X-MS-Office365-Filtering-Correlation-Id: b6011af4-ef24-4bb8-641a-08dda760dcca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2VXZGcxL2xrOWptcGVDTlQxL1YwWDRRbjRycmxXeGpXR3hZdm9sY3Jja2E3?=
 =?utf-8?B?SXUrc0xjbmJWbTJzclQ5bE51ZWpTMFpFa0Z5Uk43WjJzWFVSLzdEWXV5cyta?=
 =?utf-8?B?WXpBRkpCamN1NUNMTnB3Y0szSlpVTTV2QUpkWmIwUFVGUTZvMUdZdUM3YlRM?=
 =?utf-8?B?c3FieUxSamx0a2tTbjBKU3Jhd3I0eUdDS1htdDF6elR4aVBld0ZzMDRmQnhF?=
 =?utf-8?B?V3V3Um1IRGhRNEVXUWRSVlRTd3BXY3pxMFd4WlV0NExPSHcxOUo4ZEwybVJI?=
 =?utf-8?B?VVpMdWdRcTlDNlV3enp2M2ZuamJpTzkwVHRMbnE1Y3NHaDBaUlduZHdpeWJB?=
 =?utf-8?B?UE95Tm5naWhMTTdZWkJrcVdNTm5kV2U1ZFM5aENUNVQ4Q1lBb1k3Z3ROZmZi?=
 =?utf-8?B?aXhjNUJWK2NhQlJQeW1OdFp6c2hrWlFXb3Mva01Za1FnT2crM3VNSkZzR3pk?=
 =?utf-8?B?dUpoZWFONEd3bzM3cGdKWUt3YkdZbVdtYlVMVVVJYmpvdkdvOGd0VWZ1dkFG?=
 =?utf-8?B?Um5YNU51R09rZHkrN2RUaHJqZnFHZnhtYzJYbDRQMGNtcHpEbmhXbVV1S1RX?=
 =?utf-8?B?U2VMTG1TbHhEN3U1UUM1R29YY2wrV0pKTHhaUE52VlVxc0xYUWFGTHRraFh4?=
 =?utf-8?B?OXcvYjR2WUNQSGVvVWVjT0cxd2dBOEdTTzB6SHh5UUFEQ2Jld1pqZUlUM3FB?=
 =?utf-8?B?amhLM1FRaFZHYnYwZ0gxVE9YSy9DNjN3ejlDSEU1S3Nnd1V1dWJZZEpTUlNW?=
 =?utf-8?B?QzhuRTRBZkZpam0yTGVzY1dmTGNxNTBML0RmMVVqekcyeTY4ZTBLS2YxMGRP?=
 =?utf-8?B?bG5ITDFIcGRnb2xCVmVNUklXZjNtMSszZXRtb0JUNlYxNU1JTEFraDZmRFZT?=
 =?utf-8?B?dDRMR2pNY3duY1RVRU9NYjBKc2M1MWg3Q2FJbzR3NVpuTS9CK0JBQi9kL0Jv?=
 =?utf-8?B?MWRBVXdEbGlvQnpTc2ptclR0YklZeGFhZ01PZUFwaVJwbWVFc1BrM1pmSFpv?=
 =?utf-8?B?VFJkdmpQck9hRk5ranV4eng2bDk5Zng5eFBaeG0xNEdYeGw3eUZGNExDa3VL?=
 =?utf-8?B?NVpMOGlmRG55RytQcDdxN25ReUhNT0g3YlhUNDRLdWVBVjVXQklWOVRReW1n?=
 =?utf-8?B?OWI4bGlEc0VncTY0b1U3V2tPRHc1dG1pMjNpQUVkMWY3UnA0YmhBTEJxYkxW?=
 =?utf-8?B?eGIybXBVcmVHZE50azMxOG5qRTZhdXltSXE4NFk4ZmltMGg5dXR2UFRnUmRt?=
 =?utf-8?B?bHhLdUc1QUFDTW5xZXlEZHpIa0xROVRQVG5aSFVaQVdqZXJMZEczVS9LeG92?=
 =?utf-8?B?N3IvSDFITVV2bHl1WjZXdkl1NnNmZkZNOU9jS0NwWHBxemxlUm5TbzllWHR2?=
 =?utf-8?B?anZzaW5BV3d5WlVyN2ZzQmxyM1pMWGViOVNtZ1BKV1lIdEdZVUYyNkxSTXpN?=
 =?utf-8?B?REdLRGZKL0poSUdOMGIyRWlZLzFYN2RzbTZucGlQNTR3dHA5azFZdE1pek9s?=
 =?utf-8?B?UlkrY0JFL0JDYXJCZ0QxTWVVeWlCT3ZTUWZuYWpsNzZoQ0NuSWpoSEVldDRa?=
 =?utf-8?B?L1M0NFhsWmVpSjRWb09KdlJxMDhxZFBtNVEySE9WNjZtWGFFS0daeXB3ZzF5?=
 =?utf-8?B?eExNMzZqME5yNUsxMFhsbG0xeXk2STdNbEZUT0FYU1diMUlVaFQwRGRHcDJF?=
 =?utf-8?B?Vy9NSThpdnhMeEppZ3lWTWhxMTlwODNJMThuSlhNRlUwaGVkeWR3Zm9jY01r?=
 =?utf-8?B?cmUvQjduUWlIK1BiVG1RMDJQdm9CdmZ2WTJjdWRTQmVLUno4RHFJNFRLaWhK?=
 =?utf-8?B?d3Q2SnU0Qk1ock0xTGJySlptTCtrRjNlMzJEd1p1djYycjkyQTEybUNBVlRy?=
 =?utf-8?B?Y0h2VE5xQ1RIRHRCeDJOUlBWZWtWRmc4RktMcWxkR2tCSVdtaG5IcmtrWmNa?=
 =?utf-8?Q?wUCf7CwJRgA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXFUUi9kZzlSQ04yOHBzZFNsNE1oZ29WYnF0OHA0bWVkYk14ZTVDLzNiOUlw?=
 =?utf-8?B?OFh3ZTFoSGdNa2pIRkhtRngxb0tjeDdqaTkxanlBVHhzZWF0NFpYNDM3NHFV?=
 =?utf-8?B?NWZ3Zmt6WEtlMjZYUUl1ZnhtWnlwa2xiRFlHU1BiaVZLeEpVdVFEUHVoeGFW?=
 =?utf-8?B?VFNSUmdKdVFvblNMbzVQMWRZRFA2U3VpU0VUa1drSTJmcDBOSm5mYTBKMm9X?=
 =?utf-8?B?aDhrc3d0RmJoU2tKVm9PcFV2ZGNrMjhMVVVGM3hxOU9Kdm5zakZVNWxPMVdk?=
 =?utf-8?B?dTZSVkwvbzd4TFNPOHZLd1dPb2RnTlRpZVZiVVRHOGRRN2JpNk12d1N1VVF5?=
 =?utf-8?B?Mm9QVkVKenR2U0s2UzdxbTM0SDRMTXRBVFZMdldKakhHY3dFcEhrWDNVMWRi?=
 =?utf-8?B?dHVGb3ArdCtmSVBiL2Evd09CTCt3bnpTdDVRcjVvekhFeGljenNJdVVYYy9H?=
 =?utf-8?B?eDNXR2dmVC9QNWY1QU9keUtnR0RPMnVTTWJYUzBxS2FqakVOcUhKaFhDMC9n?=
 =?utf-8?B?SUhhbUl5Z0xPSFh6a1VIK20yaFJDYWJpU3RjNmFyQTFyT1ZsbGx1R1N0bEtS?=
 =?utf-8?B?QTZWeEZQUllPKzZ6QVpwUnNqRW44UjF0U050SG05VHlobU5nMnAvekxzWjU5?=
 =?utf-8?B?Ri9OcGRUbXNQN0MzWUNRYXhyTHhwa3N1akJKNmU4ZXFCZjlla3JTT1loUm1x?=
 =?utf-8?B?VVVQY2xCSmU0bVEybzhOejdoVlZneS9IMEhENDZYYkhFRUowZUxXdHduNEUr?=
 =?utf-8?B?aStVWUtOQ0ZaT0l1MTc2VENRMFh3bHB4VjdGNjFQaUl2YmtuNUVtakx1MHdw?=
 =?utf-8?B?RE8zRW1EMkJoa0Y0YXhtWkRTaSt2aVRMS1ZqbjJVemRFQlhWZlJ5SE05M3Ji?=
 =?utf-8?B?T09zODRnME1FN0pmWlpyOVNaSnF6MDBNc2gxbXBuVjRNR3U3bEszb3VncWIv?=
 =?utf-8?B?SldMd1g5aTVlMjRWTXdNV3Roc1Zrd2hMODZ4ZkZSMGtEd3hzTGJIek0rSUsz?=
 =?utf-8?B?L2tMS3FBZElzdWdLakNIYVR2K2lqdHdJNENlOERsMGoxS1BHeVNFYU1BY2dl?=
 =?utf-8?B?MGl0cmNMNUxIY0k4S2hhcHd6SzRLVVkzMVRjb1BpWjdWMUNnUHU2dVc1QWJz?=
 =?utf-8?B?eHhvcmNhN0ZYU0RwK0RYZ0Jrd1BMRXdFMW9HazVYMmFjcjBDYy9pQzRib0t2?=
 =?utf-8?B?aHRmOFhSUlBxVDlaMll0RWxrRUdjU0FiYW1kWEx6OHhBaTFidHpGeGI4NGFU?=
 =?utf-8?B?SmNOT2xkWW02ak9IVnVITFFUZnRMemgzS0M3V0pxTlhhSEE1anNnZmpMRDVv?=
 =?utf-8?B?TjV5cVNHUzVuZmNzVXBQWng4S1o0RngyTm4rRFdLNm9oWEZ1NlZZWUFuTWNr?=
 =?utf-8?B?dEZQYkJjWFhFQWYvemhIZU9jU3AvYVNWUVhZejBHOVg3MW9UZ1dMSHowSzNU?=
 =?utf-8?B?THNibUUzMmZ3RDNQVW5BWUo1eExZMmo3T1RHbWsrVG5wU3B4RHdZbnRnaTJS?=
 =?utf-8?B?UVdSdTdoTTFmb0gwWWo0S25yeldUTkl1dE1xVnE1em5sRmNWUlVQd0ovdDZL?=
 =?utf-8?B?MGFxNDhPL08wbUE3dTM3TFBjTk9wbW50bmt0bVF1VHdwZHR3T2FmVzFRTkE1?=
 =?utf-8?B?eTRibGMwVDg0VW83c3YvclBTWmhVU3hsRGxySm5CSnZtZWVJWERUczhtVStK?=
 =?utf-8?B?eG1FcFEyUDZJdUUrZjRBTzVrKzgxN2x4TnZ0WEVrRGc0anlma2RhcDlqSjlv?=
 =?utf-8?B?T0Z1V0cwTzhpUnVkYTh2aHcrOVhYbDk5MHFDdTlhWUlhcnVXcEhtL3N3bWRU?=
 =?utf-8?B?NHBrVGRLaCtBRjcvZTdSMTRsWXU5ZlBhU2NGdEpmMm1ZMUg4QjYwUUZ0RVIr?=
 =?utf-8?B?ZEJZYjJ5eG96S1hPNjZIN0NTVHl3TVBLSlVrSnlKTHJyTUZWS0ExWHBsMXIy?=
 =?utf-8?B?UjZLYThiZ093V2F4bFFDRjUrRHVXNkF2NVpEZU4wcVJxaHlzS2U2SDlLRkIr?=
 =?utf-8?B?Mld1YmQ0cEZGZGtnTzNKNmVmRjdhMWlJdGI0L0lJcDhFcnVOZmcvQSsvWkJ2?=
 =?utf-8?B?S0VpVzdBNndHNnprRjhJelRYems5Mkc2V0FtUkRMSEg0c0NvL09KM3ZNMStM?=
 =?utf-8?B?cEhlK1U3VWRhaS9GampSZTR2RDFLOHd6TVJ6TVlrbDFseTVMQURDSXN1cTJF?=
 =?utf-8?B?cnc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6011af4-ef24-4bb8-641a-08dda760dcca
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 14:21:02.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Mh6QFOEX0dQ7ODQRBiMaFIeXHTyklnrqNetfd7z9CCoftTmo3ypsABkkfPLMqxHuTPutI3U0TGHYMaIQLZkog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8822



On 6/9/2025 5:47 AM, Paul E. McKenney wrote:
> On Mon, Jun 09, 2025 at 10:35:34AM +0200, Uladzislau Rezki wrote:
>> On Sun, Jun 08, 2025 at 05:25:05PM -0700, Paul E. McKenney wrote:
>>> On Sun, Jun 08, 2025 at 08:23:36PM +0200, Uladzislau Rezki wrote:
>>>> On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
>>>>> On Wed, Feb 05, 2025 at 06:56:19AM -0800, Paul E. McKenney wrote:
>>>>>> On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot found the following issue on:
>>>>>>>
>>>>>>> HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
>>>>>>> git tree:       upstream
>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
>>>>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
>>>>>>>
>>>>>>> Downloadable assets:
>>>>>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
>>>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
>>>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
>>>>>>> mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
>>>>>>>
>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>> Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
>>>>>>>
>>>>>>>  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
>>>>>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>>>>>> #PF: supervisor instruction fetch in kernel mode
>>>>>>> #PF: error_code(0x0010) - not-present page
>>>>>>> PGD 0 P4D 0 
>>>>>>> Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
>>>>>>> CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
>>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>>>>>>> RIP: 0010:0x0
>>>>>>> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>>>>>>> RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
>>>>>>> RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
>>>>>>> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
>>>>>>> RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
>>>>>>> R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
>>>>>>> R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
>>>>>>> FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
>>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
>>>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>>>> Call Trace:
>>>>>>>  <IRQ>
>>>>>>>  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
>>>>>>
>>>>>> The usual way that this happens is that someone clobbers the rcu_head
>>>>>> structure of something that has been passed to call_rcu().  The most
>>>>>> popular way of clobbering this structure is to pass the same something to
>>>>>> call_rcu() twice in a row, but other creative arrangements are possible.
>>>>>>
>>>>>> Building your kernel with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y can usually
>>>>>> spot invoking call_rcu() twice in a row.
>>>>>
>>>>> I don't think it's that - syzbot's .config already has that enabled.
>>>>> KASAN, too.
>>>>>
>>>>> And the only place we do call_rcu() is from rcu_pending.c, where we've
>>>>> got a rearming rcu callback - but we track whether it's outstanding, and
>>>>> we do all relevant operations with a lock held.
>>>>>
>>>>> And we only use rcu_pending.c with SRCU, not regular RCU.
>>>>>
>>>>> We do use kfree_rcu() in a few places (all boring, I expect), but that
>>>>> doesn't (generally?) use the rcu callback list.
>>>>>
>>>> Right, kvfree_rcu() does not intersect with regular callbacks, it has
>>>> its own path. 
>>>>
>>>> It looks like the problem is here:
>>>>
>>>> <snip>
>>>>   f = rhp->func;
>>>>   debug_rcu_head_callback(rhp);
>>>>   WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
>>>>   f(rhp);
>>>> <snip>
>>>>
>>>> we do not check if callback, "f", is a NULL. If it is, the kernel bug
>>>> is triggered right away. For example:
>>>>
>>>> call_rcu(&rh, NULL);
>>>>
>>>> @Paul, do you think it makes sense to narrow callers which apparently
>>>> pass NULL as a callback? To me it seems the case of this bug. But we
>>>> do not know the source.
>>>>
>>>> It would give at least a stack-trace of caller which passes a NULL.
>>>
>>> Adding a check for NULL func passed to __call_rcu_common(), you mean?
>>>
>> Yes. Currently there is no any check. So passing a NULL just triggers
>> kernel panic.
>>
>>>
>>> That wouldn't hurt, and would either (as you say) catch the culprit
>>> or show that the problem is elsewhere.
>>>
>> I can add it then and send out the patch if no objections.
> 
> No objections from me!

Me neither! And I can push that into an -rc release as well once I have it
(since it is related to a potential bug).

thanks,

 - Joel


