Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2040.outbound.protection.outlook.com [40.107.215.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB8B39FC6;
	Tue, 10 Sep 2024 03:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725940164; cv=fail; b=QohDHOC004f7hM8S5wGDkJTE5NDqhD9vDqtKR1P9EgfipTTLxtPedmwfhS04kg9TqnWKZOd7B40L1uQu1kEXGP9ClbZGMFRMqinr0jkNoOJWaYD7NWUrspnz1SsqXAsDbQ5zK3znJ2EEwWd8BNJ1IrU3oxVcplUVDlGO98cVfuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725940164; c=relaxed/simple;
	bh=r+YaQkivmL9tnFTtxzdkwMkL4qnTPAm2zsNOA397XYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=rmsriuD3WVP50U7dSJEJEn2rAH/m5zTLuBCmyQfzwH131V9+fokTXQk5ZxBeQBs/G3YC+mkyb+hyCDzNN1gQ4EhFk5UnLHhBG/R0gJqvj9/eM5nl/ycJXppCd3aZRJvgS6smBIqgoPzT1QYDbzGA12BjyB29sOpMAsjWjxlSEm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=K4nzvImt; arc=fail smtp.client-ip=40.107.215.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="K4nzvImt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qa3CXI3AlkVgE2to+5YQIGmxx174xvXm0ySFJx9oO/4da/Jg+epBGXCmIb3mS+zdZ3pamoMLCa5AeZa1JvxUPMAIDI8IRCoVKjX1abh39p+0xPehmYKibfJH3aqn7FIYeF8xgVZPMhZufIwSM1tEe6aubXwOq4tZjVFNAfR+SBkQvMRwHa+B4djlKHaSbaxdpCQwPYfAgQyRCmrVm4lOUPHRhqe1WNWFRoaYDZeqanaf6FVvlORsJdvonQDW6MoEgXtVpmbPO2TKS8nLIBuTPs6dZUDrfniiqnRsIeFqTZZuocm4G5iTxfYhtMm6U7udvu00efgesK/DeX73o5+wSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sw5c0MF+pvhKw6lQgWdxJCDxDcLzrf2NCSnhkTImcRg=;
 b=PGCISdxbMyggBGmAdlwG76ARrTvymfloGwnEQYiDBbyHbg5Ut/MNajaDWC/ijc4TNqQ6h2vmPBKM3G5rDgG5Lu/xh4B/2SKL+6zhSRsZcc8SA8XmRfmFAE40VQDU64Kkkdy+/rqZtDxoVI5keebSiB7VsLm27jLZljA8KlulQzhT7HETmmNC3S+Ov4am9REFJ5jRdWO4YaII94x3nwM0H/hpSwa4NDCc0GtzpGDXHXHPink6SZOq0q058Im2WU4c8ucZE86k6CCVINdq47XoYek03vjl+iqHOAbePWYPq7fEIq9FlHvU5sZgz92zw3KrVhM24z3yxrb4YZOWii34Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sw5c0MF+pvhKw6lQgWdxJCDxDcLzrf2NCSnhkTImcRg=;
 b=K4nzvImtKJhkZeH7LnjWCNz4alqA1oqu73CVNBpmmr+gWmm8vfmM1/H5Yd2T9YIxHclLS8MJtVZX9DD98zl/W4yZs3xfulvTG/IJ96IwOVjVUAVn+CwlzPiVq/TMRTNqd0hBmljVhhFAQ76l2QEQVMdq29AAvo04GJw+XJGpIATBk6Da6NuF/MTNJX/zeUBBqF8pSg6+wJ+B70Xz8kDunJCEkGDS2HVj0/yi5osp7wfJLtg06kEzC3+xdOVV7hjrUqaYbQAmOhmw0oWnXwEcPPclA36yEiTwMO1pe05aGUmmXeIOUiTgg0/oAcL1XMH9eT5yNfN2XdiWYxfeWzyTpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7)
 by TYZPR06MB5973.apcprd06.prod.outlook.com (2603:1096:400:33c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 10 Sep
 2024 03:49:18 +0000
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1]) by KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1%4]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 03:49:18 +0000
From: Yan Zhen <yanzhen@vivo.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yan Zhen <yanzhen@vivo.com>
Subject: [PATCH v1] bcachefs: fix typo in the comment
Date: Tue, 10 Sep 2024 11:48:48 +0800
Message-Id: <20240910034848.3217867-1-yanzhen@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To KL1PR0601MB4113.apcprd06.prod.outlook.com
 (2603:1096:820:31::7)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_|TYZPR06MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c75938-2d72-4efe-ae44-08dcd14b8c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w0FwJLOh0ZRbpfcii1SvDxAPGLIPI0wwVdbWKD6rZPHYFItWe8roQA/aJa1Y?=
 =?us-ascii?Q?a9vqugDNjxVEi5xOz0/t6RGvxuy9ten3F4fdiecH/b42i7hgswnH+QjJcLT8?=
 =?us-ascii?Q?I9yRgF/ztBr3+7ol2KHcJMntMgzXbv4F86AzDkgfhaSGKGvO3tIvdYyzN738?=
 =?us-ascii?Q?1EmgFa2NzWQY3iC1pFMGhFknKxWImT4A7QY+zWWWsqMmQrk96cGLktcpEEBI?=
 =?us-ascii?Q?r2dSQkB9RLD96PS2jNou/Wp6gNfFN+H8zsMvhvDNarZRDzW279qCOKHCKk7r?=
 =?us-ascii?Q?UEsPIR1yJE1GCGNnvzM6cYqeoaAy/6PEUOz09mwCBOKevtLXRQlIzajDS5fq?=
 =?us-ascii?Q?ZTbFn6o7mZ45u733dEHn3D/hq/Q/3fk/ioJzl6jgVldEsuCWDTxmQZX2bJsi?=
 =?us-ascii?Q?UjxPQN6GVGM6aFYGQFQ7c9639WjcQroY9aeHJWjvSHtbB71movST9jZg/2yq?=
 =?us-ascii?Q?LAVJUJLCGRpICV+QfEU5cLUSXdXguTWbGri+OB+lKolXIEtvIE7AxxkekJ5e?=
 =?us-ascii?Q?BC4dGvKunom6IOwOZQyRqG5AJIYLQfEiOiDkOKWF52Bw+BR6Q4vSspXseY/M?=
 =?us-ascii?Q?zMIvbkTgmbWF4y9PE/G1LtyhstS6nhJoKixhILYRPatxXgkea223OFVcPUro?=
 =?us-ascii?Q?7yEJj8kGrmBnWe1XrKfaAbWHp9Hqlu9tRVnb473LP1UGxbINy83wfOO3Eaca?=
 =?us-ascii?Q?PHhNeyiekg8urVTGajGNKD4ryGpCLy79vQ5E6JUKg+THsqHfynbtg5St5Pq1?=
 =?us-ascii?Q?JBKBnRlrrZFii1rx9Welv95nj1r/nrHivc2Y7wrp4ayMMaD0h+hSPah4z+ci?=
 =?us-ascii?Q?au1Swgw/ww18DKAm87Lx/coVXsz7spfKIjKIbab56ue0784TbxVypCPPvSHg?=
 =?us-ascii?Q?tsib4FbMIfUWlzF4hvhC4ZmweWO9+2NzhB/yI9Z3P9yplVuNkRF+meqGGLAm?=
 =?us-ascii?Q?gLqRGqS2PjCg3lvwfA8v3wfuALRAqfEguba82InJguB9hxiIuSVZM15x804G?=
 =?us-ascii?Q?CcWN7EmchrB66BrTkdebWcpFBcNmp2MZoDYUABpqeRBo53ruh4mnHCg3zEoS?=
 =?us-ascii?Q?grG8y0zvF6tTjkO+kV4tkeMH1gCV5yb3RJLQBYT2osQ7yNRfi5ZtUg2bNyev?=
 =?us-ascii?Q?YFMZlKtI3ON5KyJAE8DOTCwJhEb8uVsiJf3lbFjYSjOGDkkKlBoCbXwHvyHy?=
 =?us-ascii?Q?DEYEvvKunGukz1oE+Qf+GcI9JWaX1VhKF6W12rYCIPBoY7p6ppO9ILoapVqy?=
 =?us-ascii?Q?AdnJ7VTbhpA2ebgHbScoEAeWhBnu5LAsmJWROXhdcy89xb26XvjKWRASLlux?=
 =?us-ascii?Q?m+cbT69CRHZrRONV475RrMTQUwYPAxH4U0ng96AO2ZDjQNIMxLXeUGIO+BMp?=
 =?us-ascii?Q?O5SbxoiVofgmC8+SiBtXDVgIFe1oZlbTJRY3awQEEmYC1MnXQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4113.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ozbOlX4KBGPtZ5ISzf4jhEY0lpRRkqMGpI+uuoO93DpHQwFC9Xeco82u0S71?=
 =?us-ascii?Q?lklxXCNKJdHWufcve4F99cbVTFkqR0fxj4VLOk8z2ubcO/2htmX87S3gjIgT?=
 =?us-ascii?Q?wR5TfQ5mBhkMxmfwAMG3K8wf+s2/njh50b436uL2bMnnvg4dlgtdIxgjNzrB?=
 =?us-ascii?Q?LWMPj/YrRh/dYgQOOs719+QXCAFXvgv32PXIssIMsHN0d5EWuyJ5OGYOniXr?=
 =?us-ascii?Q?4/lOa+Jmcg1A9N3lSMr3FLzXVqlwUGo3dYr74BJZYcGPV0rye2eh9q5wTjXr?=
 =?us-ascii?Q?ywWg/78KQCkijbmqsHA+M+Ux+eU23Y+DUPDhj8s+EDqO0VgTsp9ptbPhFcS1?=
 =?us-ascii?Q?QQ7IiE1kAJbVVuLpC6LIcx/JbBKdPoQezROjzW15kyvIxW0KUEn758OGzUsY?=
 =?us-ascii?Q?1yS1GllZqNEl0cJz5bldFe9IlV865A4sdVw927PcX6OzPyWXwj3GCNWzlApV?=
 =?us-ascii?Q?iU2+s5nsccLgeX7KK/AnUp1qF2k10e6de+4iDBw0BshxSE5goLFX8JdYnw1e?=
 =?us-ascii?Q?+Gy2pXQyL0jkAgBnjL41FZbAXSY88R3LoQg9Tkjq/j55T+t3JSg994s0tXaz?=
 =?us-ascii?Q?hen+DxzkmXF/4AFw8uI6akb6gzERfdJmSMKmsjpyg1P0eYZwBA88xhOdi0jb?=
 =?us-ascii?Q?MQsR0eMeQyT49pIjj4EeEp9Oo55WN8iRro0rujcdcWYQEOWARMJ7CzEgYSKq?=
 =?us-ascii?Q?mHHCWCfWbWd662eVHQucaQ11gczRBLlsqLS6aRvBvODes2SmDjJygJJN/t1F?=
 =?us-ascii?Q?Y6ricmkh4OhC+PPMY5m/6nGFShFh6LmBDSOFyg0ZGSQCBP+cAmUDaejpqXM1?=
 =?us-ascii?Q?W+YeAaD0ZoK6bBlS8qoRcmve3FK5HUG9F4P/Hd1cLJnNn6lepAUq0C8W+Gwq?=
 =?us-ascii?Q?EhPyvLzciUgVD/0rk/NpKkY1ziHMa0FNeg1fP/bo1yWJklnQHUhUsDbhy2qt?=
 =?us-ascii?Q?psn0OKtaK2FG6Y97YgXk4Krz+GQTNvrj/bTASKGbC3Mlv2mnhqLzZVbMKUlm?=
 =?us-ascii?Q?31YPcaKxapVMl4XnJFEaD0uD3yCEXEvmoL94AdiJq29df+38i1+EQH6nZwA0?=
 =?us-ascii?Q?FWJA7x/KZlJFfwg7NfLGFcCYZ3tuXmnGN1uP4qSH3M95sfeiRd0OrL8PQ8m/?=
 =?us-ascii?Q?jN0N/ZpOtAdNPff8ZbZMkE+QUnv8yxx2kLayvRxv5wrjXUVdfB+WLZD2i/pt?=
 =?us-ascii?Q?AuaK5eZIzX9cP30go8C4PKeO2ofWSZdCbvpXiwRzplfCrS4bz78uFix3vqlm?=
 =?us-ascii?Q?0m0mB6I32V745248pMWoGR4t9wos6JH0ssU8ztJf8D3Xs1k8PU1L73k2MsSD?=
 =?us-ascii?Q?m1ba6RQp1LQt4iewNKHz+pEdATljX0FKi6aAJshbhT6rsE4c6tBN8wuEbwUT?=
 =?us-ascii?Q?33NvvFJ/hug6F99U6zQ74KSZOtxD4Yfj4JkpDSk4qTNuimBiFv31SCQj9OgJ?=
 =?us-ascii?Q?bgH0RwfZzPwwcv+RLYVhCkR+4UjdDTQPNiVBZFr5dFtB0HGxaLoDSGY+pF0O?=
 =?us-ascii?Q?6UOKXGwyQVBiDj+kzBCGEYUVaRiGCgBrjiHc3IEftRbkWoBGIwtgS6ex3V9W?=
 =?us-ascii?Q?85+gvTeH8VVynXuxKchEOB+6bCDlz4AD8PfhL+mV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c75938-2d72-4efe-ae44-08dcd14b8c08
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4113.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 03:49:18.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rhcbwX7r5jXjWzJNkMVvNx9PtH+JdWWTry3vGCdigEFfE6M/WNRAe+hsDkZuGOygitn6j+uNk4EffSWMMKIsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5973

Correctly spelled comments make it easier for the reader to understand
the code.

Replace 'sentinal' with 'sentinel' in the comment &
replace 'sychronizing' with 'synchronizing' in the comment.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
---
 fs/bcachefs/alloc_foreground.c | 2 +-
 fs/bcachefs/rebalance.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index bf8fb9cd6..c7a90dc27 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -1552,7 +1552,7 @@ void bch2_fs_allocator_foreground_init(struct bch_fs *c)
 	mutex_init(&c->write_points_hash_lock);
 	c->write_points_nr = ARRAY_SIZE(c->write_points);
 
-	/* open bucket 0 is a sentinal NULL: */
+	/* open bucket 0 is a sentinel NULL: */
 	spin_lock_init(&c->open_buckets[0].lock);
 
 	for (ob = c->open_buckets + 1;
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 2d299a37c..27ed8267a 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -451,7 +451,7 @@ void bch2_rebalance_stop(struct bch_fs *c)
 	c->rebalance.thread = NULL;
 
 	if (p) {
-		/* for sychronizing with rebalance_wakeup() */
+		/* for synchronizing with rebalance_wakeup() */
 		synchronize_rcu();
 
 		kthread_stop(p);
-- 
2.34.1

