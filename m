Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012038.outbound.protection.outlook.com [52.101.126.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707EB28724D;
	Sun,  3 Aug 2025 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754216586; cv=fail; b=mFooOCTAgYLK841aP1n3ThLz/5ah1ZdvgRC/DMEJ3MUUWeOvFMYzoUXCBoUwwYYDzKtyaTs73adQIrh+SxIw5zTALPR58DAnJM4sOgfv1GPFgEJ6Kcx0qgRdLacoW9nbmwEhDYew1CSk7LWjvoLg9hSXty0OtR+1iChJRPnGpEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754216586; c=relaxed/simple;
	bh=kRD1rRRoHIWstG+7lt5JHxhxwWtUofUCsCZBKipVRzY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ee6Mula++qyQQ458oHwFFIFO9OKhJq0W6KpYCLuaJB1OS3TCUigiteccgtlOquEL5b1leCW8Ls940dRqACDIbtuJNc+txsX5MsJgIKI39WEU2vOxQ8BE5alLaLrP/N3kJA78tzv2fQFgTDVv8SOa2bsKF89a+oYtmb/FZfyLee8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nqydK19V; arc=fail smtp.client-ip=52.101.126.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nqydK19V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QS+gCP7GqGGeXKuubXFvBXpDV4ik4VHM1MQBTJF8CGYrSCK02lnWXD8fXDaU7hxkbtbmZooLU0epiwrkJXoEYN8dZjsuvCJc455Hy1Lv/xdVgXlBx0RZXe3Wmx1gGDGVf/87DZWGivC+U7Uf6Nuqm6HcbBsBUNOSvbJnob7eB4/8BVa6TYTUu1Cizr6+V+TOGCttYkDiclS5zAIWiU3aTGncsbrOiXnQ9LHtUKQVDHMqiKpBrq3CqypR1UuK0cWWjmMUI4QcRmoGABbEt9krc3XDahto5iB2qNeZgcehxnN+9smolW/YTgvv+89M6tpjlMa1xCW8nPyyevJynbAR9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcS8l6ReQ3FRn80dvdyQxBdtNoAAp9ciaCQddBwEOLg=;
 b=DjUCQFZAKOM/87/Z7FiSETVaq0eesC4LIGo3Nul1pvr4rU72WLeuyNeIWElcH0u3AQ1Yhiy8N5sXKIVz0qLvmqsEYVvhFBNfePZyvwPCa0gBE2ln9plP488b75KlLBj3j7hF7mJ50xD3k6bAofJqoNH09KyVrjuQN/3K9pcM+eSHEaX4Kv7CLYzFE4ZZLxNEeFSaiVqeU1jPm/vGAw4b3rmxaFg/MxNEiVLH23RKYCjnhstkD3NPmcCHq7I+nBT1k4rza3YQmY0jd2AjPzPzaajzSmtGO1ZkNAhcgFxuPCCIzRxh9yf1ZImTUMe+6AvnxlPMgjhhha97lqe2mFQR4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcS8l6ReQ3FRn80dvdyQxBdtNoAAp9ciaCQddBwEOLg=;
 b=nqydK19VTMQ/pZyr9UPfZLeHsiF3Q7IHzcASFVMqsaHaRLnziKeJKBkiSNxM1wboYZyHT36C8JPO9pWuCbxprhJBAYb2r0tsap3R5b0zZ3xDOxuvR3i5JeQ/zlTk257tRO/pr5OU0lTsIVBW5AONJ6c3SLvYhTwrPZJwOjVxgqkbtefD/p/yfcJV1yvO2RihEFyn9iM14IRYYRhscaKgzPvSqXwKANfGNuwVebDZY857xGUlQhjDPRdZVM59gFE8di5LEoBw/X8krP2R7YzqEia6PPOmczWFeX5vZecC+cgOI8jbf1quL4RebUq2bFpbZx5Gwez4ihlVaDkCw3F7LA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TY0PR06MB5128.apcprd06.prod.outlook.com (2603:1096:400:1b3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.18; Sun, 3 Aug 2025 10:23:00 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.017; Sun, 3 Aug 2025
 10:23:00 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-kernel@vger.kernel.org (open list)
Cc: willy@infradead.org,
	Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 1/4] bcachefs: Remove redundant __GFP_NOWARN
Date: Sun,  3 Aug 2025 18:22:39 +0800
Message-Id: <20250803102243.623705-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250803102243.623705-1-rongqianfeng@vivo.com>
References: <20250803102243.623705-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::14) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TY0PR06MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: 113ebe54-bbae-4855-0ae2-08ddd277b8dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k72Uv/VdnFKTS+HaJ6t5pAaNYfSHaz2PprmLafnTFzVFRgSnMvGFD/dnhQUl?=
 =?us-ascii?Q?jG690fw5Fn5R5JLCQVS4VFhV/Df6skcyDUZqJ+uSLf8nPxinqmq3TFMHmaqj?=
 =?us-ascii?Q?fpaoQbao/uo7AsWueR23XMTB2E3wr4KKa6Epbxy39LsajCfocZ2Yp8N1svV/?=
 =?us-ascii?Q?w1n9ttrkiN/1WNgeNZ+Hd+cEgasNznFz6e14PMgJRxfNhAToN4SCFCwMQdxX?=
 =?us-ascii?Q?3A+8SFQ6hz9fgucUi6fI9ZIsNlE9RoHNFruThuAsLjI/w0a14rWXiDX/8vld?=
 =?us-ascii?Q?x8bc/5YJt1pchf/3JhsJX3QYAoy6sm6mrqk4/5PYewq9ElQwz8o2E5/WYgck?=
 =?us-ascii?Q?r14RMbS06l59FTXdaHq0SF05nF4C6qtoYRPd7pvG51rS1VekVlWpv/KTntTj?=
 =?us-ascii?Q?1/KpHJloSpdzUpqrJ+Wnl/+ylcmbdGpVqHku+ZzfjUzsQTlI+maYfEtYLeHk?=
 =?us-ascii?Q?5Q1mTxtm4bqKvQwq99ECiGcNwCeN9QZ3wyT+VkbInKOeRC7XkUBCxfk/tIYN?=
 =?us-ascii?Q?PG7AxznHO7Ac0EKGtjsMtgH08AgWXqmBsEyoSfnvVhBb1Q4xCiOiiv1N5JaU?=
 =?us-ascii?Q?iWDjYc72R/FptM332zK9qtBCVbktI5pTB0uXm4k5D4WczjGEPyOFqNTpTk3A?=
 =?us-ascii?Q?kkEv7gAYY5viaNNl9tU4H9BpdBh/t0k/uYk9soMvzBWWd4v87JbodPWCBbY3?=
 =?us-ascii?Q?kott/59oG4UxigbIeLAzZY/Ak+gO36kRqzZyYKhiud4vKS8qjhayEpOmBDoM?=
 =?us-ascii?Q?VErP1xSPEEALrC8ubsbqdYv5lWakCPHSA3x+Bf0EGQpUbtwkB7GLnS5OnTYt?=
 =?us-ascii?Q?aFKdlqJ+TtTOVP93IfmVUKyEOG4rRJIG7cS9hSh2oUKSLNqYcxKkQq9q+ldv?=
 =?us-ascii?Q?qXbONj0M5cRyPkND0v3wNJU3SkpbjWsOtalUGNfkVRIwfXJ/MkaH0SBSK/b5?=
 =?us-ascii?Q?GcoY5MvZmq8uleo1LGY5Wv5391eiuCzzM5Gr/lcLwLTvxVDtSskWmL1bNEqK?=
 =?us-ascii?Q?ZvzNKCRBeW2tWEA9HolAA5qTOMbZ1L4SIB/Kw1yMIZ//HZjREmha3V8Ce8mK?=
 =?us-ascii?Q?FvY3RroQ8BG3igyolu+/hDndpUZUNB40XYJ2ffKpHbDdyH5v3o1sPbgZRGn1?=
 =?us-ascii?Q?6Q4vP2OVT9XngmuJKPAHHNb8f9z42USfFWMcl0PF/m6McgTnSvsLO6o5vV66?=
 =?us-ascii?Q?uwvkiuCL9p1mVFP0f0JLPHTMtDZXcHCeMh2nj8gVAOTPlYgu0/R0sFOFZ6qB?=
 =?us-ascii?Q?yD3DKUs5MvqPH0SdAOLoS1mDsxnPqGYzoEC/29I7H8IJ0ouQ8bWsO6AB9Gks?=
 =?us-ascii?Q?d3G89JIQzQx7iaEmOgHa8QylZML+KJGaF4j6A3sDY3l492/hgV/uje4spi4B?=
 =?us-ascii?Q?7taLI8aIKg7+HE8tCIErswcI1+2mXb/FmE1/VfK1K95LHDbZoAXejFk6X8x8?=
 =?us-ascii?Q?BFXef1rgTCzGNaGvBkMh1AvVdVo4KCn2ABdAYAwSvoi6rahsLVZVIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AIOhxSvIOJnnZYNcfztyD4prvUCuu+cQB7fwlKXcO0t6G7hGmFTNFBiEZcEb?=
 =?us-ascii?Q?KYOTri2pmQpRbq0SJ5F1TO3zkTs5M9j5TDzM2NuPeRicZwBHS0/jFZ3DYykH?=
 =?us-ascii?Q?LTWZ3LsIeclKviNQ/0N3L3Dj9gfNeboU6CJ/yd0IaSM5lD+Yer2n03m8U0z3?=
 =?us-ascii?Q?481t0DmgeE9Y+OVBeMAqfxiTyyHcNsPquzyBtNDM0hUQv4Ih5tfM8hNc8HC3?=
 =?us-ascii?Q?M2ZoCZpcb8NSiW+dJOgyIFTV2B+c/MDNoMtI3e0ZB4qzURQeLrG+zOHCeJlA?=
 =?us-ascii?Q?G6+dXmrzuTP/cPEVf7hatYTgnSwwHK+Fe8ogogDZ5tTQ5xf/9REsYIVYxaMj?=
 =?us-ascii?Q?K/0ZycNFGQTs8pl/Or6P0tdQ3seWkmNMC3D8jUb2jCzD47JgaiOy2avCeh6/?=
 =?us-ascii?Q?Qn+LHnTTBWTXMyBajjn6/odpM1cAk+jbEzDlf2F1beqPMg/nsqdAMcnkxFkO?=
 =?us-ascii?Q?TpijfONyyS2aVay7MCJVszP3qfvq6trnSddLiyzIWr8PXsYVsQDbuVm+k8wm?=
 =?us-ascii?Q?E3/eKQfDYpLGYOvcQ6mUamkMbs290lva1eHRTvajyJnbi0cqN16op7cxfRst?=
 =?us-ascii?Q?yVkxgVMCV5D6fxrpiEs0u+k8Z39urXZk/HC0Bkjk8zDxsW3lu+cBWUtJj+19?=
 =?us-ascii?Q?VucZ1fcdrOsaCAFH5i+ceDI3z+3hNNBaks5e5MkkcL/iZQ0Wjm1S+Je383pV?=
 =?us-ascii?Q?Q+H1hAP0A3UE5GKesnloAFG4Lybp1njxCitMK1b5vaWbp5ba4qgtkY0VH/Kw?=
 =?us-ascii?Q?3Wexwkia85lVI0LZAQsiNd24CX9gkXtVQH8qctV6Fgxi6WF2G4apK0NUhc3p?=
 =?us-ascii?Q?loW2UN4lFbSwzUsrKeVDZ4m0447Jc37OghlTZkAeiutcxA8axqLFHXw3MrIs?=
 =?us-ascii?Q?Ujq3jqMpPfrQHOsd6LWAK2AFnyOv5nr4DnlnRUiJ4LAiML5PBlwEmkjwIlB6?=
 =?us-ascii?Q?myRTITuzNLSARG+aGrsPMZ3IzuMqdZmWcgAjlfog0T53VZ4lIrB+hVEykbHE?=
 =?us-ascii?Q?bE+9x9AzxVIfRBRZoU9pUWRRX4xPqu+CrckXS4R57P4AJLE/pmH4soREhib/?=
 =?us-ascii?Q?vJdXzbD0f2tCLXJRkr6LLYuccssS0XiXXc1Ctgqy/S3G2wRFVoX9Otu+Zyr/?=
 =?us-ascii?Q?T7IPK78FPdFhNHKO5ojk/Ves22LENf7F7n9kEy+mb4bNvxaJfOEmFW6SaVsu?=
 =?us-ascii?Q?I8qDgIlGisTtXupOjlw2+JPA77+E4wrM5dNEr72LKvEo00FjUOEruA99c6r5?=
 =?us-ascii?Q?yAGF9CpGWuYqhQmyMzKZiKSL06/fSYwc/dlPiBG+X1IRCTbtetzi635v7DeZ?=
 =?us-ascii?Q?2LPQCF/yeFTd/hTwrplXhE3ou1WWKgoPi07bhH3an16Hv6WYLzogX+jrOvB/?=
 =?us-ascii?Q?ClilNydZV3DlfRqBJgCSxQzMdxYsVKKqR8DFSKVGXcqxztvH4TXmxFuiKVOL?=
 =?us-ascii?Q?VR4mv3+RKmWFTjZIQk9+NmlH7HbFC7utnkkxTUgiyCMF5IqBBA5/NZfoNaXf?=
 =?us-ascii?Q?65c5GMa+LcY4T/2Cbvizl+t3CwlZWRY9SMIU/PQ8ndxU5KfZXoPs1BW+6l7P?=
 =?us-ascii?Q?vRALVv/o3tSoq9vpibJ0O9JdqwYZ43P4VYVNaq2O?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113ebe54-bbae-4855-0ae2-08ddd277b8dc
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 10:23:00.2961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26TKzcIsTP6juj7kQwgj0Zo890DewSVf0XvP8XRxH/z6cd03qgSgQ8YlVAsAAKbKrUONO1UneLGNEqZolUMM5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5128

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove
the redundant __GFP_NOWARN.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 fs/bcachefs/btree_cache.c        | 4 ++--
 fs/bcachefs/btree_io.c           | 2 +-
 fs/bcachefs/btree_iter.h         | 6 +++---
 fs/bcachefs/btree_trans_commit.c | 2 +-
 fs/bcachefs/fs.c                 | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 2f7c384a8c81..3750b297dc76 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -788,7 +788,7 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
 			goto got_node;
 		}
 
-	b = __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
+	b = __btree_node_mem_alloc(c, GFP_NOWAIT);
 	if (b) {
 		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0, GFP_NOWAIT);
 	} else {
@@ -826,7 +826,7 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
 
 	mutex_unlock(&bc->lock);
 
-	if (btree_node_data_alloc(c, b, GFP_NOWAIT|__GFP_NOWARN)) {
+	if (btree_node_data_alloc(c, b, GFP_NOWAIT)) {
 		bch2_trans_unlock(trans);
 		if (btree_node_data_alloc(c, b, GFP_KERNEL|__GFP_NOWARN))
 			goto err;
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 8a03cd75a64f..276cf088539e 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -131,7 +131,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_t size,
 	BUG_ON(size > c->opts.btree_node_size);
 
 	*used_mempool = false;
-	p = kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
+	p = kvmalloc(size, GFP_NOWAIT);
 	if (!p) {
 		*used_mempool = true;
 		p = mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index b117cb5d7f94..c8fc6ee01d96 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -954,7 +954,7 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 
 #define allocate_dropping_locks_errcode(_trans, _do)			\
 ({									\
-	gfp_t _gfp = GFP_NOWAIT|__GFP_NOWARN;				\
+	gfp_t _gfp = GFP_NOWAIT;					\
 	int _ret = _do;							\
 									\
 	if (bch2_err_matches(_ret, ENOMEM)) {				\
@@ -966,7 +966,7 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 
 #define allocate_dropping_locks(_trans, _ret, _do)			\
 ({									\
-	gfp_t _gfp = GFP_NOWAIT|__GFP_NOWARN;				\
+	gfp_t _gfp = GFP_NOWAIT;					\
 	typeof(_do) _p = _do;						\
 									\
 	_ret = 0;							\
@@ -979,7 +979,7 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 
 #define allocate_dropping_locks_norelock(_trans, _lock_dropped, _do)	\
 ({									\
-	gfp_t _gfp = GFP_NOWAIT|__GFP_NOWARN;				\
+	gfp_t _gfp = GFP_NOWAIT;					\
 	typeof(_do) _p = _do;						\
 	_lock_dropped = false;						\
 	if (unlikely(!_p)) {						\
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 8b94a8156fbf..4d58bdb233e9 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -449,7 +449,7 @@ static int btree_key_can_insert_cached(struct btree_trans *trans, unsigned flags
 		return 0;
 
 	new_u64s	= roundup_pow_of_two(u64s);
-	new_k		= krealloc(ck->k, new_u64s * sizeof(u64), GFP_NOWAIT|__GFP_NOWARN);
+	new_k		= krealloc(ck->k, new_u64s * sizeof(u64), GFP_NOWAIT);
 	if (unlikely(!new_k))
 		return btree_key_can_insert_cached_slowpath(trans, flags, path, new_u64s);
 
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index d768a7e7a204..0ff56ccd581a 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -268,7 +268,7 @@ int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p)
 		rht_for_each_entry_rcu_from(inode, he, rht_ptr_rcu(bkt), tbl, hash, hash) {
 			if (inode->ei_inum.inum == inum) {
 				ret = darray_push_gfp(&subvols, inode->ei_inum.subvol,
-						      GFP_NOWAIT|__GFP_NOWARN);
+						      GFP_NOWAIT);
 				if (ret) {
 					rcu_read_unlock();
 					ret = darray_make_room(&subvols, 1);
-- 
2.34.1

