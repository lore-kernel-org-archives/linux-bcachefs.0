Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012016.outbound.protection.outlook.com [40.107.75.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09C2D3A97;
	Mon, 11 Aug 2025 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754914219; cv=fail; b=Xkk3GuJvIJqWXqPBJMTGr5/iKHqgJjd5D/Tl6eJfadPzDnhnS1vis5clGHQXQLztGSgoFE1ZOSiyzOS78wlYAGExgIdTXlKDtOuXE037xLBiF3+BMdVGQaFAO8oX1vFx3bXu0Vobw8TEWG7lK0uVpKcB5GSpXhpGDpPqWjjhZoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754914219; c=relaxed/simple;
	bh=KdxsVx0vIy9wOG0TDT5+ofvhtbAEYC0nTN3sCn1T6yA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fIps4lfhb3CzI3Q3B3+uG4wiDhsvVzHY+CndH4WrhZsN3Sg1awtrFZOwxIA1VbQVokyQS92n2U24hiTvGn5Jlyij8jTwKI5nql5yJ7jBE8MwRq9FAXY/4mos7BHlkKHTYEoiWZgHcjxeY5pPDPcR1grNffglMVQ/vWXFuJkcoV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=J43+4Xnp; arc=fail smtp.client-ip=40.107.75.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="J43+4Xnp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+MKirhh83BdXFNJeQFPnoUGiJPDVAElfm9U1KbG8vZVWkKOXkiewPOJKUlaKcerwzP6zMZP0qHjhyzx+Wh7UN/ETHE6GzJZAq5sgDRb5GW499841tEaxMAKANHoOKg4AUTBvoqc6NGJreZ85mB8MjIwFfycYDvJuXvRX5yRLg3YLgUf7Bn5QTzjm4MakO1QPQG5ub/flscpLnIJuYfcGbc5ZG/4w5R1HGC9uIRlmhmv8lgkKSRQALs5amTy8Zdg2q5UhW6sluHaihnm1Q6r8KW29qXrcanJTNsY+hvgikmsslyMJM6kqgf0cbtdZlybnGTQ5pNFI4VEBaGytMS8iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jzO9VW1wDow6xtWuZdeBP1IDNz4HVx2PNClK1g3t+k=;
 b=f8CoOJcgv7lR1psf0J1L0d+WP1twi7A4uBc+t78emfj0HbS84FpYeBEpkXqEPbRbvLpIZeSjxe2NvNFGNlVENoEKOZaH1a8FoHt0+o7a/oHHH0Xbi4DrO7pqKDuQQ2q9vWEYY2DfBtdGs6QpOM/05R89fQeXyWOBgmMDgiMKNbhFeqUZ9PFzHG9i4NgnT40VNPqhOuInq5hi2jqzRf0DNLj1kGvXlDyEwecGet32EDGugH5OIRx2HpvHnfMuqNMc2t0+GYPcT4akBwteRPua8ycii/9WOo+hrNRDsFeQkbyLJAoUqJkUMn2gd4LPpUiwWN317GVwrVjmFU7LcdIs7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jzO9VW1wDow6xtWuZdeBP1IDNz4HVx2PNClK1g3t+k=;
 b=J43+4XnpD9wScfvfDmCQae3Nvs/XLOSlmeeD5iM9XmtsrJz5dTMA29SZys6CuiFy2CpQfKrzCTmMyPUhSElsb8Zmw+h+4YvHW7hdtBFWHbdppMF9zo/Ni7emrqZZm0NmaF7ozzkjYcdNvCew5D1su+EzLqV4aEYzEK/K7DmuNoFZsmMXhZlzOQK8/XHdnoaaczhFxlU8dtjCag0Ig59HBN4CK3qRN/xaP16nAuUNposY/VCSk5otu/S3F6UDNRX8bCY/QnZq5OcoNa4C8F/AN1Vd860imYvjvd+xw1lCPjIDrqXVm/BEWUq9RL/NWsBUK7uYW74boBJ02tx5Hh02vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY1PPF93F545ADF.apcprd06.prod.outlook.com (2603:1096:408::91d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 12:10:15 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:10:15 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 2/2] bcachefs: Remove redundant semicolons
Date: Mon, 11 Aug 2025 20:09:52 +0800
Message-Id: <20250811120953.529864-3-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811120953.529864-1-liaoyuanhong@vivo.com>
References: <20250811120953.529864-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY1PPF93F545ADF:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7f4258-d6ca-4dfe-0790-08ddd8d00778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p768zQRbjo8kFDdvRHrgq53OUQjri4S2c/N7R2b7Y07JXWr5fFPsP6ZCKMyd?=
 =?us-ascii?Q?csrl5LqIpNsuBBA4LJHZH/8V1+dcRfijw/ajilHBPIlJTN/kD4RtRvJL0+qh?=
 =?us-ascii?Q?jPqm6ZwwqLROQwQno6MwxQ4BPnJUzpaZ0AboV5MfDBDdi5nijNr2HyxE1rBR?=
 =?us-ascii?Q?h06QvgfSW4dKcp7FiUs+4uPcIhYUhHiWvw1EDCl5SUvoVydbMv9lE6LgWPkH?=
 =?us-ascii?Q?DbBYP2O/pNcbApD8BD/TbA0S1eb1hYbUdnC+YQ08tiBPqS909Lx7kUAowkGN?=
 =?us-ascii?Q?wj0Zh11bQsR07K2SW+v3DvcCldEBYqlglW3S/z/G4MldmfEBlakJLLdWQUJi?=
 =?us-ascii?Q?EMxBKIhJWbWbi9wBsCqDIn14jcc+TEAmguMENXPLjuUDaj/USICI1pRef7X+?=
 =?us-ascii?Q?nQOaMDeMuyO6Vuh+8bd8SjRHbLPTe1dTYRyOe229cgMXDuHfaK/pr0jEGAI9?=
 =?us-ascii?Q?l0AbrcC/aDREt9ONURWzALyiGL7hhS8a0j0Nrc1em4jtxrN6uBcA5huUiJyS?=
 =?us-ascii?Q?JoxEMW5VR3Gt0irPlqVS/yFKHjooQzVgiTITbjPV1UMe3PqQbWegLVRWNmvg?=
 =?us-ascii?Q?4gJ1Y5a+C5T/kEBlhRfgbcEwzxOGrtDqLfD+9AlHkQUn4paxBzixPclBJuH+?=
 =?us-ascii?Q?yJ8GVXsEuYBKsbWF6bTJ7ob1hRi1T/jRWqkNxUrBbh6vRnFC54nvEddsGdkj?=
 =?us-ascii?Q?WM1qzI2toMkxHhp6oK2nzdXtC3yHN3BYU5eBffQNzojqNKTO43VQC+prWzyF?=
 =?us-ascii?Q?d9HvjWIyrCwXXNFrcdBNcRBfJZAGXcx0lCxUME1hADlG6IioCirwWuZZ0N7a?=
 =?us-ascii?Q?aSWeHDRj2C4FUmqHQMdLY2oAAMVyVodhBGYO7M3fr6cHaH4VG54iruzSmVSM?=
 =?us-ascii?Q?9X8FlzdjWPDhFbNy33rFrNGlQnZjhMkkZ5VQVobjoHe+JN5SJXYWbJuXWkmZ?=
 =?us-ascii?Q?c/1QXBcACIjmvrWplcVbvNswewPLEpxhnY9ty4hwp/4NcwSV3t4p2cBwod+E?=
 =?us-ascii?Q?lUruELLQeMyum4ti0p3pqcgguOxImzsfvKPRd/vFe7vnASkLDaHl2aw4afpT?=
 =?us-ascii?Q?4vBjYimAjETGQ0xPy6FhOEGx2k5R46Y6QbmAuO/z99ZcRQekBvFXDXhDl6ql?=
 =?us-ascii?Q?3Y1XeStBCRTLYdkih/BXOWYhd587FRO+Pl06J++48DfIYBH6AhOuQFdUOqtW?=
 =?us-ascii?Q?cU+kwn7aBAeFuZb51r8yFVDUy99aBQR8XO8oTEk3bbgRrpEKac63E0KGwjBH?=
 =?us-ascii?Q?WcOAmgJwuPU3nHbr6rJLc1LNPu0cDUdq0dnl3JDaUjccotLd+H2aEcHpKmoX?=
 =?us-ascii?Q?o5Hez/G5c9VuPicOB4CY0+iM4nPrm5FRwAk0K/HJrjE4FgVSUtiX1wgPEb+Z?=
 =?us-ascii?Q?1h1UQ9isYCU9ZTYPbXZv3tngcwt5FQOGeVgyWj9eae+vfE6335YislHNlBG2?=
 =?us-ascii?Q?A1xwbCkUn/KMYdL4H6pFMb1oB8+p3cvg/NTf4inIkm6NuXgBGDS3rQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0O6HedT4SI9yrKLoP44lkIA5NkgXpG0qcmtqTRZpjAWhD2kSX3ooWE9OSmov?=
 =?us-ascii?Q?m9VxfOhl06c3l3lAdJF2jugQrQtFYpxtkQ7gz6c5S69HZY1waa9aZMzTGb3U?=
 =?us-ascii?Q?OymfD1OyS5maiQuvRWZz8sAdxW7hzXT5tUv2PFbRos2+/SPFW7rTBvMAbFP+?=
 =?us-ascii?Q?L74EiWIL1MLUY9pwp3XdVdM/uC7w24jvLawzMk8Cd9rObBFkUabWmXSdQPQl?=
 =?us-ascii?Q?1B3QrFU4grWZNPbnb4sv646VoaZMc83BRFqOAY33TgUy5leCZybKbhAwZjqd?=
 =?us-ascii?Q?uRCjyVIitwCKmbUE1NjEJRAQJIZyBoPX3/RUga4wZN9Uc1JwqFKtDAKs+rS4?=
 =?us-ascii?Q?El9Vj8K8fin8gC7aLrqvdP6T7d+M6UAqNEzLdIW5124aO5DMEXcT6AKtbkjK?=
 =?us-ascii?Q?/r4KBk+mzKPFv4duKLHGUoJCNV7YU5XXgDo96/VoxHS0EtzL/ZZbzIKKmAu7?=
 =?us-ascii?Q?F9HVufHb1s9DrBb+ZxdaKw9KQgRBUWFM/mNB+mbhM8YZLNmdniCdwDx1p08r?=
 =?us-ascii?Q?hJcaX+H9ukUt+7sFr5OHTECKywrE5zdxmBZjUV6QXx3CFNeDpS0f+CSyQeYf?=
 =?us-ascii?Q?guj0hO7P42iEL9QJMToBn10+eKIzPmQLjiEG5Vp3F/ZP04K+Jusv5dWlKy2e?=
 =?us-ascii?Q?+gfd34tWTM7VOZKjPyw7Bu+UJBhcW4HI3g7/cyzJvHl2eLaxNw17WiX2TWKQ?=
 =?us-ascii?Q?5eZRDiN0DxZ8X03EpRmQddRK2h9qlNHXYQChJ6SBEdEPTT2zdYGG8p9JuD//?=
 =?us-ascii?Q?FnRNysvNrizbfFZuyPahAbsUD+AVjP3tX4d8rtjX397+vTc8QxbbtVddddA7?=
 =?us-ascii?Q?hereNkNaGqFG5GRAhSdmsYThGt73kiAVfEbf9tMCrQc4+imIybOxU9a3289L?=
 =?us-ascii?Q?v3RhQsL9wGTZlqGi6K6KxYutC45gU1ehh9KjK5eB5uzaG1O1jjKglrbgzHj5?=
 =?us-ascii?Q?EUk1YNiGw1XSo3p2+eW/QVETeUwqo4SycwwQViQQX985MFzxtcI7zRkajsbK?=
 =?us-ascii?Q?hOEITL/btCQqr3X3W+j8jsacv1srqXBAjBbB20ObIqFjdphc1GyQ31BwPJks?=
 =?us-ascii?Q?LGhbzEsk278O4cq6d2cmo2FSvvGNOHwYjWLsxfJB+6iq3Fa/jr0w4DifUk2i?=
 =?us-ascii?Q?jyezazAiPPBUf4MWFu/5ST+px3o6/Nkg7uyzTggjcvNU2mqVdkJNEvkb+fNf?=
 =?us-ascii?Q?OUq/jniiN+XuEddD5Mov+zWOlc9eSZDUtit1SmIt/jHTH/ZhHjjpUV/oGioC?=
 =?us-ascii?Q?LbwvxXApSteGdCvuHQU+wXoERhNtW8CBtQtkPntSsP2UGhPZGDo6xT9kUwC6?=
 =?us-ascii?Q?BiD+lzmNi2Gxr4ZNYV/2HWt4sTdYcPcXWcxKwtFiSODrGgD+ebiwh1nlFBTs?=
 =?us-ascii?Q?LqVPLg6FsUsmOVWQbTilR+NkeAU/uTbvpwglSIJ6xIjFePaoM4DqMiDbVdnl?=
 =?us-ascii?Q?z6HGwCdfSN5ckY4felRSR+bHjcVNfhp+XbsboPDjpo6ShNnSHH0s2EwupxLJ?=
 =?us-ascii?Q?hFDy02gzcOIkAp8+cbpSxtCNVPIAYg/9R0l1Nc3Jtspv7PBCACQfEjpmhFqa?=
 =?us-ascii?Q?74MKF0mpllncWR10l+sh+hpURYnGZP1xAFAqpwax?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7f4258-d6ca-4dfe-0790-08ddd8d00778
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:10:14.9589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmWVBZ/+2FZFvYl1ock2QgV+PR/i9wya7vx/+Dk1zKwBzAmCBVj0DLvpTsyTWxy50Gqx2fJlvt+EAa2Q8cgLqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF93F545ADF

Remove redundant double semicolons (;;).

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/bcachefs/btree_trans_commit.c | 2 +-
 fs/bcachefs/rebalance.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 4102a3cb2410..0d266de2689e 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -340,7 +340,7 @@ static inline void btree_insert_entry_checks(struct btree_trans *trans,
 	BUG_ON(i->cached	!= path->cached);
 	BUG_ON(i->cached &&
 	       !i->key_cache_already_flushed  &&
-	       bkey_deleted(&i->k->k));;
+	       bkey_deleted(&i->k->k));
 	BUG_ON(i->level		!= path->level);
 	BUG_ON(i->btree_id	!= path->btree_id);
 	BUG_ON(i->bkey_type	!= __btree_node_type(path->level, path->btree_id));
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index e1db63d75a99..093c72baa6a6 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -304,7 +304,7 @@ static struct bkey_i *next_rebalance_entry(struct btree_trans *trans,
 		 * work entries in a darray
 		 */
 
-		BUG_ON(!buf->size);;
+		BUG_ON(!buf->size);
 
 		bch2_trans_begin(trans);
 
-- 
2.34.1

