Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013013.outbound.protection.outlook.com [40.107.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39645139D;
	Mon, 11 Aug 2025 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754917349; cv=fail; b=tyf/rxw1NIqPA+9/BiciCJ4FRKNlF+W9jWXL40GLR0D63Yp0faRdcJzFsc77WGSMsg4bwhol9u77hB70nXtDeVG8Vr83ETm5F+5vdZj26sOJ4p9/CZw7bWnRvMZr4f3yyvnzyP+kjEoRJ7+egbrhu73beDbewMIHU1M6GPRT05E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754917349; c=relaxed/simple;
	bh=kaCzQNF7j816WnVm3ER83d/5uLtGKziz2tMpHaiWIDk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qyywb5W9XFCIgjPM9ZR0ekvztGgSngdWnbfYRJLfaPg/SYilcgFXXjl3NolwuHvCgsgU/iKI+ARjCu+6XbHUafhjbyw36oZzWQPX6dFHRgW5F8Vd3N2F6fPwhKKyPfxbxDQKYQyVEkqjIX4QdW8o7F3c9BsC+Na5xZkGjBbAPjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Ng/ElVtr; arc=fail smtp.client-ip=40.107.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Ng/ElVtr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6XuRt3/4y0/k/kaJWZLIX1FPtf83qCp+AgjjX+ZL8/5LTp9Nwkdq28sAX+fG9+fvecU22WRyqcX8kO+0SpL4CGuwRCxaSFX8XB2jSHzCSZBpaMxKeRI7E5Vge631k8kXV5EGnLAZFYYRTgZi6UaD0lWG89KZtrA24UlfAieFwGRealFVbcqzjUJn8/EAY5deAHZGxLI1jxDNLD6fN0eDdCmJ5xHdJFb/cEUU+TXRY/4V6eLaz50zHSbruJI1FMAYVHizrWpeVPOMNu0R2relWs8WfY2b2kNs2rS7jbmeXrw8NXAMGaOMVqVcdwF1DpWKTDfY/6Ak7TzhtKeY5iPJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSYFJ7R4RNJ8Rok17llt8LounOlkezBr2Hwu0Fh3RDc=;
 b=WdCNBauosj49KvwkXMagCVaydQxEZ4fjcFuARyHFSeKCDNsHdLVyklKAkiYZ5QKAJBAFXejpzhw+6em8XcHSMb/mfpi+KW3vCCvn2F6bxAu0vegpde5jqY3YqDDBLfP3e5Hhs9v16FsqLOKBYhXaPNnvTO01UiH1yfV93wQvrId016j54l2vooK5jpHNxnzLEjSjVQo8fKbrGQ2sHT6n5P/bXRlUb8XTvmacIZ4e7VxXxidcZ9vDmLkj+BFnfnckcC4RltjScCJ7N1YhpWPx6+xh6U1VX2ai3z+cYp2e+6+Lyf1oidjXwk8iqeZQJu7ptFyVAR6I0nvbI7sSBd5e6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSYFJ7R4RNJ8Rok17llt8LounOlkezBr2Hwu0Fh3RDc=;
 b=Ng/ElVtrBgWwGx0bBsbmVERQWfrkmD/nIFiP3SIcTGx+IY9nc5xBB8QLb7ElunO5NUa2hW88nR2Tv8gP0auiPbiyej72RWX7wZF38ePGooyR81AqWpvoa/i+81WXglTPZZjUNBYEpGyd1bEcdgykS+aK9Wtp8sNY7BlEruPu4NBFV2hk3c3IRRUprjWWG3un+TvGR/PRh1KsHBQx+ScteR5ccS5pzw/tnOntqpVYZU3GUuAqrSugvdKp0LUrJPZD7YmuwURG43tWwkuo+26Uxd3LYtwt2Zdb2gLajJ344d0en1pQYS24oLuWjzELFHxxC7eTBCiGc8cMxH0Repfesw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KU2PPF3DF13290E.apcprd06.prod.outlook.com (2603:1096:d18::48e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 13:02:24 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 13:02:24 +0000
Message-ID: <c5017d41-e83a-4139-a155-23247659673a@vivo.com>
Date: Mon, 11 Aug 2025 21:02:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] bcachefs: Using vmalloc_array() for array space
 allocation
To: Alan Huang <mmpgouride@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20250811120953.529864-1-liaoyuanhong@vivo.com>
 <20250811120953.529864-2-liaoyuanhong@vivo.com>
 <1EB1AD1A-C14A-4A1F-A97B-55F956D241E7@gmail.com>
Content-Language: en-US
From: Liao Yuanhong <liaoyuanhong@vivo.com>
In-Reply-To: <1EB1AD1A-C14A-4A1F-A97B-55F956D241E7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KU2PPF3DF13290E:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d068bf6-ba96-467e-072b-08ddd8d750d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWsyZ01kYTlNVnlsMWNjNGdyQXQrb3BsZm9TRkFtczljLzZ1RlpSbGtMODVF?=
 =?utf-8?B?SnNkdGJXbnlQVXNVZEFmRkM3SU1TbTVrNllaTFg0QlNteSt4V3I5ODM2Rmtt?=
 =?utf-8?B?YVdsbzVFVVdHOXdNUU9Kb1lyb0ZoVnM1UDVPSm5KS1YyRTdUVll0dk9iU3ZQ?=
 =?utf-8?B?RSs5eDI0Lzg2RFc3QVNJWHRQcUUvTjJHV2VRck55L2R1VGU1NHNLc214dGRs?=
 =?utf-8?B?aHMwTWx4QVllSE5BVjV5K0VURmZFZ1M4YkV3b2oyUUVNTlEvblFWaE1sWm5Z?=
 =?utf-8?B?d3BQK0FRMFExNnM4WDZ5VGJiclM5dEo4K2FDSUxvRFFaSUZEMGs1Y1hXZTY4?=
 =?utf-8?B?WFo4VVlkUGZZbGtBTXRrUVRwaXN2TDFJUFpJSlZxbVFLT24zUWpVY1UwU2N1?=
 =?utf-8?B?a0M0N1R0T2F6TWRLTjZ3YkRuV3ZJbGlyRHh4M25OdEFOS1kvTU43dGpDdStU?=
 =?utf-8?B?QUZoR1l0SkxzTHdoRGNMRGp2NFNrRmlWcUlNKzcyTGFJUytEUkpUbVZsSXJS?=
 =?utf-8?B?UVNaL1VoSXJlNWdxOU9kdi9YVVQwa0V0WmxOVFV4SjJCbEpVMHZaYjhYQWFE?=
 =?utf-8?B?OFZ5blhydzZldXp2RlhVVERybDRBcmdUdlNOajZ0Vm9UaFZIdTEyNEpXVm5u?=
 =?utf-8?B?eEpSdnFYdzFhQVMveCtONWk2SDdmNWdjcmlMSGJUT3FIUWNsamxmWUV3aXF0?=
 =?utf-8?B?b3lqVFF3QzgxcU9wRFpSRlIzM08yYVBxZlhxbFFha2d6bUdER3grek1VZlZS?=
 =?utf-8?B?V080clRsUlpDTGpSaCtHZUdXTlFONHZhd2VnSHhDNGM5eTRvREF0MVNsZXQy?=
 =?utf-8?B?di9jdEIrMUd2YklockZibURlZnErVWQrSzZzNWQ2ckZLY1M5c1F3TlRwakN3?=
 =?utf-8?B?Qm8rdHp5RGNFdGF6Uk15K1h6Z2NtekpEYlFMR2pDb0ZPM0U0dWMwM2xGYmFD?=
 =?utf-8?B?WFNlY2NjTGdFZnY2RHFJdG5MK2pGMHlVbUI5amh2ajNQL1d6SFlTMmZtVkRv?=
 =?utf-8?B?c0xvbCtrOEkyR0dMYzk5RWdWNVNqNDJmaGp6RVBXY3lZVWVWK0dSNWFhV1J4?=
 =?utf-8?B?dTdEVS9kOGtuRURyRWUzUDR2c3dSaE1aSnpuSDN2MjkyODRNRHNwUlF4SVJK?=
 =?utf-8?B?YnVnTU85Skx4MEFyUnJpdkd4aCtrK2pvcDJmWk1qYW9jSEpLQVdGajQvQVV6?=
 =?utf-8?B?ZzdvOG1ydWlxOFRWVXJza3NZV05pSHVPUmMwbmo5TGpQTThsaE9CdlpBMVpH?=
 =?utf-8?B?YnVxNnBsL1NNaVJoc0txVkFRdGYxOFZVZ3A0SHJrK0hXUmhPeURwWjliajIx?=
 =?utf-8?B?WFBjUEh0cWZkcW1qWVVoQUdkdFdkcllSbis3WEJFUnlGVW42cmEvQ0t0UlJz?=
 =?utf-8?B?WnhxV2l3dWZWNnNubU4wT2gzWkhxMkM3bi9mOGhub2p4MWgrM2IwdHJuTU5C?=
 =?utf-8?B?SHhkYW80QmFqWE1iUEZ1UVkxRzEyZGErMDFKNmVOL3N0YlFZNytzM002Yld2?=
 =?utf-8?B?a05mRklNbE1Tc2xFWHlwYjM5OTlvZWEvSnhXZ2Fzdi9pQUg0UWYzWHVGbWdt?=
 =?utf-8?B?RUZHQitUdm1wQW1hUndlWmR6aTI5Z2NhbGhmRVBlS1U1S3dQVTdZMU9RQi9M?=
 =?utf-8?B?QTBGZXJjTGx6NFVxZ3hSWVJvSWcvZ1FkZ2FUcVRjUVJpcis0YStJTWREQzVh?=
 =?utf-8?B?cVdOVkExakJJbXZ6VHRmWVBCL2VYTUVYSmhNOFJBM0ZBclJuWGJZR29MdVVF?=
 =?utf-8?B?dVozM1hJbXhVcmdxeGlqL0hyRmdhS1Y3TzRSZmdMeWJITU92YXViOFFuQmM0?=
 =?utf-8?B?SEl6QUVYWnh2OE8rR3dIWS8rTDB6djIva1FvZVdPenQvajRtU2dBb2txWjJ3?=
 =?utf-8?B?WHV4ME8xTGtyd3Z4M0prbk1oZXhyNFlhZjdWUXpCeU10V0Z3WDBiWkFaRTlF?=
 =?utf-8?Q?0FnkhHGCfW0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnBmaVRnbXJHeCtjblY3UWgzczR2MmQxejhCSmxrTXdxK1h4K0dRWlpodHhn?=
 =?utf-8?B?SmlCZFN2ZVdYV1IxUjBiR3R6a2tvTU15QWVOSHVUNHNOUVFDNkwwajJ6eHc0?=
 =?utf-8?B?UUFPeUJlMUNLTUk2K3d3YjZLU1dhek5CU3VMN1FBYXA4VnRwTUZITk9mRkpx?=
 =?utf-8?B?Kzh4U3I5ZXh3VG9kd0hVb3JIK1JTTW4rNmZUM1dOTE1nSmVvcVovMm5SeHBT?=
 =?utf-8?B?UVR2SU00SEprM1F1N0xSTytGU0ZWamtaMVF2aHlFMG1uMld1WTU5TWFiOUlo?=
 =?utf-8?B?a3pmby9CYi9RdnZNaXlseVBlck1LWXdGTDBVa3drNWhqSW1hUDJ2TDVHM25F?=
 =?utf-8?B?QXFrWkRRNjN1Y29JZDdFZk1TTUFJSmd4Y3lmN1RUTEpNOVRLbVhjMlo4WFA0?=
 =?utf-8?B?c0NLeHFtWHArMGg2WWZIZDlNcnNXcFZTT2FwZUJ0OXdGYlJ3cXpqNDBRc3Ji?=
 =?utf-8?B?aFFDS0s4SGRHRjBOK0NhZ0dzcmZNRUJYNU53ekJvYmlpU0NockV1RVVLc3Rw?=
 =?utf-8?B?LzYwMGsvY3lvdkFsbW9lYnV6Z3ZTRGdOSzZtWWRCRUdQMUl1MkN5b3FZdkd4?=
 =?utf-8?B?V1ZjMzVoRnQ5QkhpNzlqYXRJZzBWcUJxUnRxNW1Fb1o1bUplaEl4UHZlclc5?=
 =?utf-8?B?c2pYQWQ5MjkrK3FTaVdzaVVKTWxrb0FaZGMxY1ZsTGUzSkF0V0Y4eEloZW42?=
 =?utf-8?B?aHB2V3BvaFBWbWdMSDZIb1UrOTN5WnRHd2NQQUVneG5iVktJb0tkbDRmOXk2?=
 =?utf-8?B?eXJWeDJHZFpHZjZrOUlwODlBWWRDQ3FDTFovaDM0U0gxOGtIbC9QVE94cC95?=
 =?utf-8?B?WXdGTExzdCtiMURvamJpR1lLL2g1T1NBNGt5Yk4zZklOYmk3TzVYaVhSOVBw?=
 =?utf-8?B?RUc5WWtuT0svRTB5bXA1bjZFMitFNndSeEVlekxaekphaFdSNWY2Q3dkdVRw?=
 =?utf-8?B?aXEzbnd6UWZmWXdTVlFNb25TMERKbjd3RXp4Tk8vcmQ4TzVEbzdhcTBQM1RB?=
 =?utf-8?B?YnpWY2NUR0o4L2NmMWsrRlFqcm44SkNnL2FoNFZBV25ZWjdhK0JBMVpxNmU5?=
 =?utf-8?B?Z25OSFBUMlcxVWN3ZlBHeXBMTFEzOHdNTFhKRUZNS1N4RStSRWVqK0NWUXgx?=
 =?utf-8?B?Q0pHL1pkT0dJUTR2UHVBWTdnR1ZWczhSNk1YWHBmNG1HR0lzaUI5MFpoUFlW?=
 =?utf-8?B?dUI3dFBvU3I5RGhnVTdMc2pSRS9UTUVEbUpOaHVQODJaUithSjBrRjd2dVZv?=
 =?utf-8?B?R0N5SW1RNFRNWWpCODAzcXlXSjZYR25DcmF0dkpyVm8vdVBzV25aSzBCYU51?=
 =?utf-8?B?Z3Z4RXhxY3lURDFaelp4ZXJ3cUh5NWQ5RitIWm1wVmp2Y2ZMNzl1YXBGNDZY?=
 =?utf-8?B?RGJOWCtDcy9nMVA3cFBEYWJSMEhEWlJjSWU1cmNaVlZrS1BQb1B5cmlEbE1O?=
 =?utf-8?B?U2tDVnFZMlA2dHRucGk1YklUc09GUmRIaFVySTR1V29LZU1od28yNXNmWlYw?=
 =?utf-8?B?Ni9CLy9qNU1JdmFqZ1FUTGJUOGRnZzdBelVlMS9UdjFwc1FKQmF4QVZZa3Zp?=
 =?utf-8?B?TXJsOGtFbEIwckwzUGJsWDhaeXd0OC9oT2tVU2FmU3ZTTTgyVWpja24yaGNV?=
 =?utf-8?B?WVE3ZHlwT05LVW5mYnVJZmR4MWl0SS9IMVp5N1RzSGlMYW42QU1OYXRhVDln?=
 =?utf-8?B?SkZUWlhIb2kzRmdUOTl4eTZpS3Q3YUtQK3c5eEJHSkJJQTkrc0xCd2poY3NZ?=
 =?utf-8?B?WkdNbUJiZmpQUjhJM2pOd3hTVUV4MlljdEtURlVWdDdxb0d2elV2bUxhclhB?=
 =?utf-8?B?c1pyRm83elEzT3E4djNJRDdZUThZNDdEQnRFVU1Wdi9QVmFnNXlOL2kxZTYy?=
 =?utf-8?B?by90T2FFRCtHMkpSZWFyRjJKeW1XTGZHUWRNM2xJbUc4ZFBSRmNBdmUzelNF?=
 =?utf-8?B?UUwxTmxEQVIxOWt5ZXhXMW1GTTBYd0RsT2U3Q1pQRzh3bnIxWnYwSVNrc0NQ?=
 =?utf-8?B?bm9TYzNNQjdldjZXc3QrZmE0Rm5iMUdUQWdMcW1Cd0JPTlNiLzl5NTdXQlEz?=
 =?utf-8?B?YVlYMkRTYjJSZHMzYm9sVFZUUTZ0TjVMNVg0N3VDRzBBd08wWEJTbHl2U0VZ?=
 =?utf-8?Q?o2SBztZXCtQWAnJNotT+yrLLL?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d068bf6-ba96-467e-072b-08ddd8d750d5
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 13:02:24.4536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsJ12qGq/zEOC4/zUh904ayaebiNPmnWJ3SgUhBz+iGV84LZphdBur35FE941rOVhvkhKpxUmt+Fg9ry1RYhIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPF3DF13290E


On 8/11/2025 8:50 PM, Alan Huang wrote:
> [You don't often get email from mmpgouride@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> On Aug 11, 2025, at 20:09, Liao Yuanhong <liaoyuanhong@vivo.com> wrote:
>> Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
>> allocation and overflow prevention.
>>
>> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
>> ---
>> fs/bcachefs/btree_key_cache.c    | 2 +-
>> fs/bcachefs/btree_trans_commit.c | 2 +-
>> 2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
>> index 4890cbc88e7c..8dd70024e513 100644
>> --- a/fs/bcachefs/btree_key_cache.c
>> +++ b/fs/bcachefs/btree_key_cache.c
>> @@ -136,7 +136,7 @@ static struct bkey_cached *__bkey_cached_alloc(unsigned key_u64s, gfp_t gfp)
>> struct bkey_cached *ck = kmem_cache_zalloc(bch2_key_cache, gfp);
>> if (unlikely(!ck))
>> return NULL;
>> - ck->k = kmalloc(key_u64s * sizeof(u64), gfp);
>> + ck->k = kmalloc_array(key_u64s, sizeof(u64), gfp);
>> if (unlikely(!ck->k)) {
>> kmem_cache_free(bch2_key_cache, ck);
>> return NULL;
>> diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
>> index 4d58bdb233e9..4102a3cb2410 100644
>> --- a/fs/bcachefs/btree_trans_commit.c
>> +++ b/fs/bcachefs/btree_trans_commit.c
>> @@ -396,7 +396,7 @@ btree_key_can_insert_cached_slowpath(struct btree_trans *trans, unsigned flags,
>> bch2_trans_unlock_updates_write(trans);
>> bch2_trans_unlock(trans);
>>
>> - new_k = kmalloc(new_u64s * sizeof(u64), GFP_KERNEL);
>> + new_k = kmalloc_array(new_u64s, sizeof(u64), GFP_KERNEL);
> No, it’s not an array.

Yes, there is a problem with this patch. Please ignore it.

Thanks,

Liao

>> if (!new_k) {
>> struct bch_fs *c = trans->c;
>> bch_err(c, "error allocating memory for key cache key, btree %s u64s %u",
>> --
>> 2.34.1
>>
>>
