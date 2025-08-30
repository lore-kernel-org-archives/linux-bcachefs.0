Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013021.outbound.protection.outlook.com [40.107.44.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7981A1E49F;
	Sat, 30 Aug 2025 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756562330; cv=fail; b=F7cvawYFh9jKLziD9+yf0ArSUTcwRKmNimIGXPus08nIm5dHOMZ9iz7HKaU5ULS0maeMRzfMAFZxmnaqTTVpmEJs2JJasR/2LF6UHiRphkMr74ebRDgSkGRpf8CpEev39CpgW4mYh5pN/bRytuI4iMHK0S4GzTyUCoaf5n0ntiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756562330; c=relaxed/simple;
	bh=v01pOLJ58DNmG12PwMpXbjkHJjmDyW7l65u7j3J8BAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=KW1mTyxhnT2zU4wapn+6AMEYcXlg4ZyLhE+kLk33q3wRBcrvIErlUeqkNTFA3btw11SwMNlH2N35sosFBbV7Vka65DEnxQ2xEwxjTpdn9frJ7H9oUjLTVPpQE+y2dniPXU5e870PgIBstu2U2RMZlxWACdwNCAZNpk9Zo30rY64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=fhJBks5D; arc=fail smtp.client-ip=40.107.44.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="fhJBks5D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/7TS8vZJkWn3VDLhSFBGL2gl7vf+Jt5sYl/LFRKSccIQCPh/1PJMpOL2i+XAdwNTDjYVnS81COso4WZw50qm47H9su3+wZI7Fji2w6PM/vBOCtVqQg0sih8LIvTfIyqH/SH1ABhlhpBfg2+52U2Yke5XuFdwfsdzjxWa/2dX5cJ8BIL9hF0EMYjAD1p2qCHJXPJSNF+3RRgszU+8K5yW7kFTba7cZcvmA8Bi21lBgQDaI2C49I7twDHaO+t3dwHF4Hm82zaYJ0SfteGt+3ODXJyw/MJjfyMTYuiFRAHG7X0+xZdmoc8qpFAekjr1BBvn4G2VQ3YPSCwgRBwKK7PcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7NmUV6jHCCAeqfJmSjq/13rY18JdhwZbGr76vCKBhY=;
 b=j4rAbZwx2hYVkj9cM9ZlnsW+7o5NdjLhJA853VQm/iXP+4SItpy722swqbA0lBvL8+YVqrcqOZkGUOeXrY8RlEG7H2Uy/Lv/Z2DnU3zudni18LgyT3k/Xfo+xcHm9x4X8P/DfOcGU2I/3F3rYaI+5Jp729EBgX60Eg7l84BDD9fou0GTz0KN3FLXHmmtIsELHIeeoPl2t458TTOaW+rOpM9ThP05SiTmx7SC65w12+syLWuXGL5IrJWcLbMp/+qMvjehdmw+fnd+4d0zRhwn9QDsYPVEUVg7aCXCZaLbLKIiAFXVSURuZxgnvRKlvuqmoFs08pLyuN9HjrQkgz7u0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7NmUV6jHCCAeqfJmSjq/13rY18JdhwZbGr76vCKBhY=;
 b=fhJBks5D1/m9f/LiIIJ7rj9CzsH4I9vCTEuoLjGO1JQ6naO6iV9KkrJI7pB/HeBpgCBspUk1QVDxBvecXDLrAAnePmf9di+kUW8IddZegdRSOcHsh3+FgVilQ4alzvQX4zBgnual22l9Qkg91u6FVwT7UMr9uUW0IC+NGpwroqTwMk+HXTu3Y7KvCQZ5v17JpcI61I2wdFH7FBBkJ23qkKPbstlPyec8elAPUJzatYSUp9dqg9khsL4oi0j08v17/4JslF/Gp7Do39iqw7x0mbtf9+x+DL5opFqbG86JbARpgT3CEiaY4z3evAkXYMHJbog4W3rKk0CmbYRglBinMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB5694.apcprd06.prod.outlook.com (2603:1096:101:bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Sat, 30 Aug 2025 13:58:43 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.021; Sat, 30 Aug 2025
 13:58:43 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] bcachefs: Use int type to store negative error codes
Date: Sat, 30 Aug 2025 21:58:33 +0800
Message-Id: <20250830135833.112327-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::16)
 To SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB5694:EE_
X-MS-Office365-Filtering-Correlation-Id: 23299b37-47dc-47d0-8292-08dde7cd548a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n7mJ+rIyfJuyCxiQxqXtvBntH1AYdx92111h+wueX5hMI72p9MQvC8naiNg+?=
 =?us-ascii?Q?yV2t95UBaiDiJ8Sk+japBH+IFz51pLIQMhefVKzUEXk0EcqBce1LZk1lH1y2?=
 =?us-ascii?Q?snLrQk1CGDspMc75qFCjWUdtDyQJ20tK0e4eV4OhNPbnZT4Rm/otEYneM0F1?=
 =?us-ascii?Q?F5LM0T2FEJdXYXPdN43IS2M/cX1q/ZSMx00JfRXZ9N9TlJN/xSZFroVxzfE3?=
 =?us-ascii?Q?rOyIz5BKalQKvNqvUpH3dcrWQb4rtPn9ILUnbbrG0KO6ZCU3VqjYuDeFod4X?=
 =?us-ascii?Q?SsrQcBLpam4oCLymWAA/p4ofy2vRip5148Xi3p5mDH2qrTRBcubbgMzFCSqm?=
 =?us-ascii?Q?ZaTErgJ6pkpTuw+bC62G1ePG5AlzYjFUqVBFlvxzvFisyS1CK9V6+ahVfRhZ?=
 =?us-ascii?Q?XYDAlmyPVeYIO7OVTvFtfe6OrrrC8znOdh+lpVkiyTqwQCiYUIjDCpDPP0wB?=
 =?us-ascii?Q?A2fGRVao20sjxJxQhZxI5wupu795funIz91LmwO31J4otRbcu33gP4HZlP2i?=
 =?us-ascii?Q?ltVEWaIJXLV+jHnojH1mGG46s5OBXtB8GonT55pm9zBlVx4SPHn9JxOMJQcX?=
 =?us-ascii?Q?RCMGJdjstUO94eq50BvpbRbp6W5tjwbEdSuTyoZe6JRjKjX/A5H12owlJ6Xd?=
 =?us-ascii?Q?XMW8J1dnR5OGz4V2NUOYEl5eu+o3CY6YQGEm0aCrHCXc5zCjb/WeAh8TWFYX?=
 =?us-ascii?Q?BJw14zcmNB/imJKVSFYJBUMv7ZBAGN0DaAxtwwSd0wGlHi8P0ewO90TEh2us?=
 =?us-ascii?Q?I9CyQ1Cu72n8FN9/Ccg1Nz4YXTd6Q+HEuZIC3T9dH01pe/XbeD5AQL4CueQn?=
 =?us-ascii?Q?OTmZNByl0Zmh22TtuBXaPO2/XzDn28rXO4dxBMqZK5qIvf6LkUPPDBwP9gy6?=
 =?us-ascii?Q?e2paw8WRmmRNC7QDz9Xe0BmrGYnpji6YdcxzUoI4rrmc9BaGD45ZL/RRFbYj?=
 =?us-ascii?Q?ntaJiJkwsjbphLVgcKjcQX6xCcka/idhWkncKQTqskmz+othh5DD/BLUpUFp?=
 =?us-ascii?Q?H1KqqYy876ZEVr+er7Hh2jT3wcCRluxwDBGJsUKPJRSv986POLLVb5McvnQH?=
 =?us-ascii?Q?WAwobgTm7c1ylDRJMhO+1AVbdmJiX+3B5pBbqSw9VsrfwYBzu5tr7uJw9LcQ?=
 =?us-ascii?Q?wtpqlpYInSHwAstU2MJmS0gXcNjMrdR8NqsfB/OhaHaKESOS3WUDe5m83+1a?=
 =?us-ascii?Q?1QwJPEArqLbXUcCuVNGlnVLgEQe4Zd5RZvT0sduAHYC9+0q3Mi9qO1OeheAv?=
 =?us-ascii?Q?Dy+CWaZWxfkb61Lc07PJon+wzY36akepJDLel306ld8tT7pxabapeNpxeafA?=
 =?us-ascii?Q?uaxvVc908DY63znyU+WP1lqJiafkgET5vhWU3FnYs09jCVDePoq2xFafVjjA?=
 =?us-ascii?Q?WoB/pfdYv5UTokZkYaU4JXZna6+IYrbmSz4wh70qLOOrbZMfY72U265SModq?=
 =?us-ascii?Q?NxAeabUkbzYBVOqsOJqECgebwzLiMKu7FrI4tfQxsiHumxx7GcLKyg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VkK0gCYOuq2M8Oh3OoMkxumz33nRWT0CksoukPsBoX8THd7hVQO4FsMy+mHd?=
 =?us-ascii?Q?xy0AliLM7QlncyEohiTfts2cQVsDoC14TPlxh6U+p3dKDfcNYe/k7RiMUZyr?=
 =?us-ascii?Q?WNYgmL4McSwRJTWsiYfLEOJRgYLxjZakJ/7XtakMventX180A43nBnb6HlZ7?=
 =?us-ascii?Q?fbNHMp5HGjAY33qR6UfMBqi1Ad9Wd1u0wMCo+9CWQZYCOvT8aoK3hF/Ww0Qb?=
 =?us-ascii?Q?n+dJSLzwp/9CS8DteCm1ISbENYXDbseMS2cC97pcooruNzpFE6TuD+jMB7o/?=
 =?us-ascii?Q?vfpmJvdyBukkMqbg5gIoxe1gUNfLuIHnWRAG4WOcuYs67xvWRLWpbYwV++NN?=
 =?us-ascii?Q?3Ls/4jcr6+XA+waUvNFZZ4n0Rzi0+RXMP321yETyijf4z3mYEgZfHimFEe9u?=
 =?us-ascii?Q?SGV8BRFyKDixpFgKD/zBor3R5+mf+JAeQrIPme8upLQyNJwIl7FcOIHyNcM9?=
 =?us-ascii?Q?GPKwFgF9q4utCCc62kw9ggkAJuCWLsWWKeRidoGOr4tO24oa2RpwlKIhyYtV?=
 =?us-ascii?Q?0MjHYteOu/kMp69tsCLroBsYUK7NCQSSbmejzID4nvA2KdPOuVPvSautaYuN?=
 =?us-ascii?Q?mG40TKG9eldntHq7pMx+evV4rTpD+vVirn7hCC+iGmuvWXRIMpHNpy+7ovL2?=
 =?us-ascii?Q?DX7jqx522hTrf/mPsJonaInwlue8rnb8Uc22SOdQbMPoTsAN5v/D5hFGfM7j?=
 =?us-ascii?Q?sOobYLS5vbQblgJs5qd6Rp8ndpElgGyiZCAANmgPvzTaNxE7mA/m01H5QCCv?=
 =?us-ascii?Q?sRieduG4kwzlv0N/ifb8InTLs8yGeN40It8geXGU7IbVXymPOuT8JS/X1xvd?=
 =?us-ascii?Q?3ufkDAklGExAPTaKOiz6XqxaJy+m9pDmZyKDreWLIfBrI3zIG4xk2sACMqfX?=
 =?us-ascii?Q?1/rzyqngyRIckInCohaFXLzIPabmMdFVXBgGIXuilO/MOorMWd3Vw8EbJoeE?=
 =?us-ascii?Q?00DDUx4fPFfJmx6F6pE9SBEQWxWhrjX9+kkPsRZQYgyErUiXZocVPQXkBBNQ?=
 =?us-ascii?Q?/yd/n4fOoSDujXCKKQqHkfFD0vjFaaT8c3NZCU+7etrRB0qyrW1nk/yS0+X4?=
 =?us-ascii?Q?kJmb1w4HNDITjIZivkSB9coJ+Xe5XS6hb5p56aQeAVymgei3r1hUrbBI9ZTd?=
 =?us-ascii?Q?NmACfISDHn5PhbFmrg8RKx6lFV6ejcIVXYR/9ys/E9Rrj1JUaFSdcOfDEozP?=
 =?us-ascii?Q?XM/2YdpFDHFLVYAcbfL6ahskC46QE93/ZrzofpAKnXPXn08KNoiUFkpG5PQJ?=
 =?us-ascii?Q?7wtr63RvvX/EBTY+T6WGcbV7rnxSgegYxKEXp9Zlr1zBG9go0aKzaAI68449?=
 =?us-ascii?Q?+PKnRXjNmevwJGGX3z7HIqqhoIbU6MpAzwItMzLuboOSm8TNgAxjY0V9zIjX?=
 =?us-ascii?Q?QRek8sN4VzHs/VPeLIKowV8Ebnh0CdwzdYpTYTdDHGOtIONJrV3S7qGG1+JH?=
 =?us-ascii?Q?iEpfUejfQqrAChbTGiDUE62vHg5XxvFHzc9J9oT9XGwvB7CT0lANFUSKZ5rv?=
 =?us-ascii?Q?DXMBAjRY7lxMGExfWMhnLXZFTRZrzOCidJx7y3+dWmKPh8hN2/zJH/lBE8Bj?=
 =?us-ascii?Q?ao/6/fjJL6/5JyCZJ6pnEe8Qma4Qwh1yQiD8tXXk?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23299b37-47dc-47d0-8292-08dde7cd548a
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2025 13:58:43.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxgzMKfckLAv5kdYRQNdJGvQ9A6hpYhoEqYAypnmlSgt/PMokoC9AzZjA61UgzCw/UMc2W2WfEMlAf6qCnTGqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5694

Change the 'ret' variable in __bch2_dev_attach_bdev() from unsigned to
int, as it needs to store either negative error codes or zero.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but can be confusing. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 fs/bcachefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 793c16fa8b09..ec20ab0ad84e 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1769,7 +1769,7 @@ static int bch2_dev_alloc(struct bch_fs *c, unsigned dev_idx)
 static int __bch2_dev_attach_bdev(struct bch_dev *ca, struct bch_sb_handle *sb,
 				  struct printbuf *err)
 {
-	unsigned ret;
+	int ret;
 
 	if (bch2_dev_is_online(ca)) {
 		prt_printf(err, "already have device online in slot %u\n",
-- 
2.34.1

