Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010058.outbound.protection.outlook.com [52.101.128.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1C7136E09;
	Thu, 22 Aug 2024 06:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724307736; cv=fail; b=JM15PEri/rM2KGdomFK9dKSZPwmu+N2KVPXQJUfG8zJyoMSvf1r9CH3xT03q5NxUEZZ/VCXHKRxClak/IHt05R8VO1sznohK4Qu+uCLjEZHCo5lJHm8H1RevXbHxZoKjt/E4nmfKA+XsoDGm3mjYf7bYXxyOq0sixD1sY51/+XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724307736; c=relaxed/simple;
	bh=o9EJCzjKIRN9BPy7MRsfmOMggyALZ11+ppje5qxw/oA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hv2NG/VvkiH/Rjttv4gMfSpzUakrlC+8y5Fpii9Mo0uKnE3HtSV2SkeSetAXMn27/V9BooxT6uexdqXX8kDFAr8jR7XGIiqqH9j10FcDCBgUJY1oUJqW5iaQHuIKu2A9ZsiesC6829KOPVFmRcw6KEQOtcY2LR3VtQ8ppKUntk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=IgbEgzcH; arc=fail smtp.client-ip=52.101.128.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="IgbEgzcH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tx3ZJZ2TSzBX5+PQIkp5DMHMgtimmrtnLf/XADCTmPV0BXy2ocf1wHWEHW0LeGvDm5SiLd+G//AIP7w9a/6QHtuM/dqU2JoP2ZEQtjcLjUTljFZp1xxzZxOx7VYXL3PUIGsnmL46JxsCGIOh6dCucuRdcYIHOl1T+UXiKccXPZugpb2KNs8q/h6JLeERt74/57zdnooR5pnNHGf55hmZyA5XQra0e9gF67eGUS+6YYIyAnE7aLDsZkBYQ48+RApV08BPaBcYcqylBZH0RsSIoGZf059OthLlifxX3cLJUKLH0M1KwOEiYTcsThbCj0C0XhPVF9xow/wCg4M58kCdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WO6GK1a6boIYGsIt21nL/tGWNRUUJCkpTXwtNqDNh8g=;
 b=h0uKnm1crdkP0X91w7FXc3J8/tfr137MZ9vzCcPCKDshNpWrqkbrVHsZ1K//MWYjvQ/00nRB0L1EPivG+4ck6vncg5tjqmSOY3aOcZcEdDiozJjPEXjpMaTJpGCirkofBo4uSyGg6FFjW/TWDG/TY9kv5dzU0sv8UY8/++UtHXKx7pVHftn388VDSfJOmA/opVUXZxuYOAU47nUlbswgN+vSW7kKAvlvEkLfoEw10id0jVvtaGJUpGyfAOlG+Wo01q/8KKDF5nu1MrsPQr1hEvO2BAbqNIWsrRN3PrMHeyRlQk/CTi7wpwbV7nS1qeHi0DFa5QCbrA7cyhpAp0UMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WO6GK1a6boIYGsIt21nL/tGWNRUUJCkpTXwtNqDNh8g=;
 b=IgbEgzcH3OgI3a/JicnxNhPd86nv4v7TI3ZaGOcoQQte65hfGUmrLxu0S2a7SIezTEtZXOSZ0NkuItq1sDgiETPHu7LJPRXcnLHkT/vrh5ievL2QplRfZy7lO0sHuDmscXbzQcPVAWnDdobYE+D84Pp5ccnVSdfx91nBwhlB/IvEZV8U2pIpGFg/6a0B1fLtsszPws18IPRZex0Ci6bkJVz9O3qXoVlZBBNmpaOdb8CFNJ+8m3fobzVeVkceQ5K7tSwlKUUDdbO5iNStHIbrnUCYZovQztgdcr6HwHZpwaE6QkCQetkG63ldNH/jYlDXXcOP2ySdI9is1ssMXm+uPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PUZPR06MB5724.apcprd06.prod.outlook.com (2603:1096:301:f4::9)
 by TYUPR06MB6027.apcprd06.prod.outlook.com (2603:1096:400:351::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.27; Thu, 22 Aug
 2024 06:22:08 +0000
Received: from PUZPR06MB5724.apcprd06.prod.outlook.com
 ([fe80::459b:70d3:1f01:e1d6]) by PUZPR06MB5724.apcprd06.prod.outlook.com
 ([fe80::459b:70d3:1f01:e1d6%3]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 06:22:08 +0000
From: Yuesong Li <liyuesong@vivo.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yuesong Li <liyuesong@vivo.com>
Subject: [PATCH v1] fs:bcachefs:fsck:Fix double assignment in check_dirent_to_subvol()
Date: Thu, 22 Aug 2024 14:21:58 +0800
Message-Id: <20240822062158.1314554-1-liyuesong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To PUZPR06MB5724.apcprd06.prod.outlook.com
 (2603:1096:301:f4::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5724:EE_|TYUPR06MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 85c03f85-af50-4122-3886-08dcc272bff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dqcMVOGRa9LxXqrqkkG7YfgqzLXwHrZu7oqbqMVvnc2nG1fn+4Kc3qIe4CRj?=
 =?us-ascii?Q?Eqqw1TlgsvBPQin1xNuWyseQcXmJekptHZ1D5umr/N3Xs1Yi2KU530DsgJsB?=
 =?us-ascii?Q?ePkEXB4VVPHeC5eleryUGpPSsJJY8p1BhTpdZC/BMgxEhdc6sEjCaCun/jXh?=
 =?us-ascii?Q?pMb3gItAe8omDdl/HevyzeHIVmNAiod1taf2j17N/1fW2D09nLdz4FZoP0Fg?=
 =?us-ascii?Q?kNq6ZlPBOaq8odwT9LTiHlTPJyi/rwOI8cSKM7HphZMj5OKIs9VTKupVh9AK?=
 =?us-ascii?Q?kcp6/2mz+jIw8nPQswF+Vby3pvIj/mKwiYfjgXB+M37cLDcnpfQnjgenfe+/?=
 =?us-ascii?Q?Cld+jqJsVYbVFrVqU46lbbNwQ1fj+KOPYWNgp9yS1DWNLHIjtmv8dWs/pIQ6?=
 =?us-ascii?Q?4D9S1SgAbiy28GybE7NdWZmAJcdb0Jyn1gtzcqg+vrtahXaQO5xE0to+7lhM?=
 =?us-ascii?Q?tfURi3U2Ms5CdymoBKOthoa7PppO4UytfrgT0Hy2Aekg7lPzdVmT+XLFQ+Lm?=
 =?us-ascii?Q?ZCNuBn3gtyVWzBbCYYohyunX2P3Jo7XI8LZreaGOJeVN1/fSf19u+ErQRgTr?=
 =?us-ascii?Q?oetrqLaLinR3Xc996CvJ2oi5XDalNpni3Vd8ue2LFSd2GfrJNWk/25GFnNQw?=
 =?us-ascii?Q?1Ah91burweVwfLJ3B4RC/N7K5JM9fO1lxFEOhjynqDR9IkP6u9sCeDchKvlt?=
 =?us-ascii?Q?aXPaV9bupPP36OALurfCADz7GHtF1FgCzovd8GLdgLCLOFGSRn77oKdJlHbB?=
 =?us-ascii?Q?v2s/Tlqhwe8bsbLnIitaKX6AqapTJMBqFkmR/oDuWjxhSFc/ghXgt1IwkiHJ?=
 =?us-ascii?Q?+Hi4Cod+EcnPma8aZSiW68EBo60ICN8OeuIlP/ItbrrD3DNKdcQ2q4tmRfHQ?=
 =?us-ascii?Q?rbLwjPjps+2S27RaqrqL66p1YoQnEXYtZySTDHA7mAtp8foypo9tpzNlh4NB?=
 =?us-ascii?Q?6eb5t7q4xHlDLKNSb1wIRvvAJ/L+jj96zva+qTZwOsEeNnWhy7tQSh+e/A8D?=
 =?us-ascii?Q?FpR6dAZkT0OmSax++OhKNDQOKe5xm0JWJsmWZ6PzAhFDBM7Xzd1p2PZTFMDQ?=
 =?us-ascii?Q?f1Gndsgucs46K7fTbb4swonp277suD8aPt2qlw35en+jrhqlm9DLwUxgrd6E?=
 =?us-ascii?Q?52jekHdPd32BIgvUe4fNKU7CDP84B5TKWafjojXYZc5MUZ1DfJvntoyFOuh/?=
 =?us-ascii?Q?iVO/w3pFWwkzEj7XL9AZUWw03eeY3xOY4XVIATGuyLg0ZfTD396Ioh4rJ6Hb?=
 =?us-ascii?Q?d6KBEho0Q3DQm/2+F1bkMyDnTwDZSUx2GsPPLzxzVSqz6QF4XekyxQ6EJa0g?=
 =?us-ascii?Q?ulamx/0wW3k9OOuLcJt0Z3Weh72S0/SA2OV9khYkOJUjeZ6W2SoZRxidTezP?=
 =?us-ascii?Q?ASi3SzQcJtANkLAWKdI/lCLibkMx7F3nHicahbUZ9GDceKQdnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5724.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yC2U5ku49HyJt3Z50PzPOk1/elItZEeLNd0Zb/jJsZAlxdnThF0ubDIz3T9C?=
 =?us-ascii?Q?K1/bxRX1YlfVEePuF4ekuQibSsBp8+9kynLLyq6PMFM0A/eqBXeVO8v0iRwp?=
 =?us-ascii?Q?gMWC6I3lf+qBt9fGTcoC5VnljGKijzEL2MUwU0RN2tZgCt/rcLvwlDnvEHK7?=
 =?us-ascii?Q?3MtD6dIomrFn8v+vpg/eMq3xbQONgMKR8AOr2K8TEvhL1S6IbKjxPWdaAyVc?=
 =?us-ascii?Q?OVIQekCpG1liJk5KPXqsMTYqbBqOWiNK1+kM3RX+ezWO6kXAoKwfzchnruQA?=
 =?us-ascii?Q?Uol8tEyj+qPPifK8qhQXCF9je1Q72IqKomSPcYpT6Xjtc4BNPm4kiLu1gUmv?=
 =?us-ascii?Q?vSMXCGFoMwhjU+tTpX+8glTS+qjP2B5YlgM96e8t75MejfWzGLGZgXMN6cS+?=
 =?us-ascii?Q?md0MPgNY/4a2efYO6pELwlPvXtjCSKK+2Q7Hdrdp4vlKjFrL6Njdgc/9C4n4?=
 =?us-ascii?Q?V1wJ+TbG3MYL5kmBfucnNBTZTj3VGo+DTNDo8qnetRy4CXd/GsgV0V/JJiCu?=
 =?us-ascii?Q?sugkgzxOrl0Q23IPUBMsI6AXaZrkmgIyfNRBK6rQBwJO16fZQqjeGz4U38q8?=
 =?us-ascii?Q?6seBVPWMAjkJuQsA+i9Gv/Bbr55m8kqZU109nJMLEYb+lvJ4sphKMujD2jw+?=
 =?us-ascii?Q?uWAMeGQrt+xn1n/Kyy5fiv4JU+LyXTGcsnkxvcKTB0wbvKIhTZVmDCsxhbSO?=
 =?us-ascii?Q?9nmoje3HHYAT1kziDKtbVVuQsZ9ZlFFDzKHxF7CZ9NVsZd0Unz2SJWnltXim?=
 =?us-ascii?Q?B26FDt3FZPN+v6oaSvhzxxoaSUXt5bwTzThqvF//R8Qu/AZOhkUFiXTD7SLM?=
 =?us-ascii?Q?NI9awe1GlGlCs1nPE92hd0//bf3U92NqGQbSfzXirZIAEb0zGg75r1tOu+Xd?=
 =?us-ascii?Q?zwmwf8Bkel7+0pGvv4nR+/MoqWTHwoUvYOG28nx8PyruG27+assX5SogPXH+?=
 =?us-ascii?Q?BgzBGMAGTl3sdDPaETC+wkgK6Z1E+TaUkMpwmxBtk8/zVa4CjMkaQcDOAftp?=
 =?us-ascii?Q?7zit9TGV6gvUuoJNuHfYsekRDDUNp0/6LMeVsiCuc8n8svUGmKo06RjSKoP4?=
 =?us-ascii?Q?dCNfB6e1WOhYFxWgRB7xr/UuRmKhb4U/CNitFGsj5/6ff/Yw/5gU+xSKvqVq?=
 =?us-ascii?Q?cLzw1Yuz53FKVKa4aidDTOsAG/UmrYVzsGzCjrIkPBF8X5EGZt/au0A1bjHg?=
 =?us-ascii?Q?DFCK/iMxKGYRREqLKeRTqNCldlwCDR1c3f/uGwITMT3yh+rdPGVGaczOj1wA?=
 =?us-ascii?Q?SwYP3qOsR9eZPjk/V7RPkzXUukntrgVikHNYRT3a8e1A28/ejrxVNJUzsYvD?=
 =?us-ascii?Q?mc0oNBZacFaOMuZPVtWArL8mR1vvio+73LNAJ3RSGiw1TO6ld0mSjLtwVWAd?=
 =?us-ascii?Q?R92Nz/OfGaDCV7pEEgBSMbd3adTQGe9yAC8lCegvTcMJ4DSCksmqXBBP7Prj?=
 =?us-ascii?Q?lAxdXrQ92UpRO60vQjiLTWh43KzQ5yF36bSTYLF8TY9z6Ue3oKDfw0q1ZKKi?=
 =?us-ascii?Q?xVeFwfJHFivk61A1kw9hahi4YbSoWrDEOKhaec4UP6pCDtAmy20vsf05En1z?=
 =?us-ascii?Q?0Y9D19fMugamjPUm+Uq9lmq9PI0WKUV8u/lfmZZC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c03f85-af50-4122-3886-08dcc272bff6
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5724.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 06:22:08.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6dQFFcqr/d/IptglV7qyDPpL+bLdXZJZ0pDpBO32F7WKf1QM8VmExO8IgAwZKRmJ08qigDX2WI8oTb/MKqdyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB6027

ret was assigned twice in check_dirent_to_subvol(). Reported by cocci.

Signed-off-by: Yuesong Li <liyuesong@vivo.com>
---
 fs/bcachefs/fsck.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9138944c5ae6..411a9795cc03 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2006,7 +2006,6 @@ static int check_dirent_to_subvol(struct btree_trans *trans, struct btree_iter *
 	if (ret) {
 		bch_err(c, "subvol %u points to missing inode root %llu", target_subvol, target_inum);
 		ret = -BCH_ERR_fsck_repair_unimplemented;
-		ret = 0;
 		goto err;
 	}
 
-- 
2.34.1

