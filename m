Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012016.outbound.protection.outlook.com [40.107.75.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE932D3759;
	Mon, 11 Aug 2025 12:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754914218; cv=fail; b=FR/+XRixYmgBniyeqRxQreaAbLhZAoU5H69B61S9paVIdOVYumXIDT2THhOMn8CXJUCUA8f8z2HZMlpK9vs8hqSY7cUYGvD9tSgVUdtA+VHHm0p7Q50aur6YpcG/QPV7p5fHu9jQkie56en/KmJdwkXeaMv6ca49lhOQL07Cdwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754914218; c=relaxed/simple;
	bh=c1NqBSRyR3OlJ7uT70efFWYI8ZY9NSZAdhzcJB3wAeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JW/LQLuafgEFk+2OZsbV/TxNGfbZ/f2ILj/wXpwVLH6X3NyrQXIgO8q65VTEWZBnuGpMCfis3pW7Wd/v2cnBVnAxn5mAKExrL3EomgEmaDbLiNRo+DAi5dpgrSM0CloG2FTZjNsaYhKD5CqpQZUL4Y0T6vAwOkPvQCoAuo7HlsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=NDYUeOcx; arc=fail smtp.client-ip=40.107.75.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="NDYUeOcx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bu++CQagkdSrIIygJA8g5OIPEy+Jw47/eLgR0oGnPCEbG9gfPYslH7W5zi3VjL1Fsj3txIQ5VFP2KoVDBGtk0tvsPf4B43UXy1Dcsyqu4xnzPSypgd2gstDaW632vGPOpxd/NCiXhpgO+2ky/Guo/c2gC9OKAUJKRw/QkHK4VPNh8VZXkrETCFVAlH5I62hPZ7PCXBH51Q8EdpikmbQEIeNhjFnjTL94SUpFQj1Pdl2RdqkMmoXfTivI7inCyGJOeadZe5UMVPxuEQn5Wm4/uTyX7bVCGLK/Alxzj5JHl/s0JtxoKEM78OdBS3ZB+7c7P9PFnU/NIYhPTBGEHuDs/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11Mh6pbwtvnrD4f/iUHjEIHeKrTqkC+HnLGvL0z84/E=;
 b=bWO2dQv3YDobed01euSuQ0vhUkLtNxi2CFtMFlFnp7/WvAfY0FJHz6+I27oWG3WEIeR8wUKijeGMUrbzlncxz8O6rq98O/RinZCEsyNdyvZrrg6mHri3RDFn0UiFjqGdn8KmDFEbBW0q1hUJwxVFo9+sLFn6DaMpM7QqrbA1Lg66WOpSFmRUcKfTJ8ngSF+0ED/gweLqgMRQkTL5Nux/LbQeew601WCq13G82fSBfb1H0I30jj5+ElBD3l8/HsCioNxpfxiuuQDQ1EWacmF1kSID1MOxNqlB8AAGzrsSSO82gaP4Hk7eIu+wzHmJjvnVbHJvzQT9X0yVvN+wxNGoyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11Mh6pbwtvnrD4f/iUHjEIHeKrTqkC+HnLGvL0z84/E=;
 b=NDYUeOcx1JVtMOP49Q1ZMDAwl448wAdt3YHSgGFPC0+XLcSmdrkfynEeE6gj3MAXXbZ9EPozjixlsXXiCnJ6l4thgxhSyH6bMpEiK+kzBwD72NexHS53i+jSFK8BpW2aL2U1W4Kii0Ge92meYcEDd8999Cqiu6rfviDcPir4IEvWEqutKFfOzQMcGwPU7st4FWqY34crmqioDTCmlVAyEKciupTSCpT5Ho9oeeDW56sILAcPXRfEwHfykr9Vu4/n/ptwOxpe6UuNTbQIWE/vqpQm8rjtEH0pRG5zSI0wBaGduWGn81axadXIOjOkHR86acj+uHy6RAmNJGgxAXSoOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY1PPF93F545ADF.apcprd06.prod.outlook.com (2603:1096:408::91d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 12:10:12 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:10:11 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 1/2] bcachefs: Using vmalloc_array() for array space allocation
Date: Mon, 11 Aug 2025 20:09:51 +0800
Message-Id: <20250811120953.529864-2-liaoyuanhong@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8138b589-c951-44fb-19c2-08ddd8d005b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QlZPbUWF+Tfat9ekNazb7z2MBgYJVxZyetEXxAO0LXVQUtkDil7jMABxP/sv?=
 =?us-ascii?Q?p9S9hMY/HZGW1IOHrvE0Yx76GhuHe2i2N95zIFnviOT4oEDZPxKruZlsVdZa?=
 =?us-ascii?Q?R9wNCun2r+ndqL46hgGTpSwOe8HScRH0pR9J/uaoUZLpRMgijYMFnnmw9rx5?=
 =?us-ascii?Q?WFa/jmZUadnAZ+Mt8o2BbitFPPKALHlYU1+myMriXXFfHGkLGcG3Rk1awwR7?=
 =?us-ascii?Q?Acaj/CVLiRmSce9wReuN9C3naVIfBqFRCspa9YU0nXh/IkRxa8e0YYoN0jeh?=
 =?us-ascii?Q?YP5eUhxBOqEnVBs+suUnSiL0FPPBfi6EqVKg7F+zl1JFyII2X4LRvY3Ky/XF?=
 =?us-ascii?Q?UoULYkCBEDNUEkfnJIoEO2+SRpVi08bjK3See1wkkdH76Z7qSHskWQHPa/+R?=
 =?us-ascii?Q?VSP8cwfafWM6QsZtMMRqw4fMnYI5XfStYG03wPAwQiq/UwvUKZpy12AklLxY?=
 =?us-ascii?Q?/IigpDRgqhpJaWayH01oXzhEOoGeROXiCFqs+HZEk3A+KiDhLzmBl1nWc8Tz?=
 =?us-ascii?Q?1Gl20gT7PUYI6InTU0Kc9X4O5w6BkkTgRo/h7nBFEFbCP8s5xyvUwh5Ef6Bi?=
 =?us-ascii?Q?7Un9BltERUtv53nfI9Vv35IjVW+9lX6Qixvat71DbHzkLNNW7yWoAxAmA/lI?=
 =?us-ascii?Q?GNvdnEd4r3DaGS9n6QsEt9wWwPzGfddeWnlqMJBUVqvFkSof7dUjE8b68Jqh?=
 =?us-ascii?Q?MvGEDgscDyHOtHL0fVlKYHZQWh3dG3f6DnzGsTSUreg648z++hywL3OSk193?=
 =?us-ascii?Q?1Qj6+ct08OUUeKIDrFAbZkkq/ZHgD0DZ8MHfcC6u/kZTaPg5C1Q4EeEQWI9D?=
 =?us-ascii?Q?guSiJThqZlRkwWRdhVFSm7QLVRypKnbBMmB7pLiDokEGNC/fPD1IT0Pu6sGw?=
 =?us-ascii?Q?C09hAttNF6XuTWaNoqUY1cbdIOCeNRITKFEK7ldtHetGc+6cKqhORYQlt63A?=
 =?us-ascii?Q?fSo8PXCPJ+9DaYxQIUYQf8dGyQ/3oV68W0pHbPhYqykVR0jxXJRZ/DZZsa/A?=
 =?us-ascii?Q?6VNg9oN7OI+BjbN6dEWmoXj3eeeSf/FenDQEjjWkgBJGXCLXy6jvDM3KWlzp?=
 =?us-ascii?Q?FjU3bVwsOCWDzw/APTAEINnwmW60bv8lYGYt9NKwgYAiaWXREpl4MHRi22bS?=
 =?us-ascii?Q?6BZpC9n9GNBGJs9j/fDIB7spvZbrMrCr0xjgOh7uoOiMLCXikbZ7i4AiPa87?=
 =?us-ascii?Q?jh11UGc/FYrTEn5mv/Qgo4A6oXcQheEjZ5t4SYjUM51QZSAWisWpbYVKi3rx?=
 =?us-ascii?Q?wE7iOwV7/amj05WTZHj+Dz7ft59mJPW+H5JCPEmJVcw62nER9Zpg9CWbYebj?=
 =?us-ascii?Q?YI8j7RJkU71xSOVL6s5gj91aWaXlN9o5u1S3y3QgUE2jj33avCD5gDyPPa7m?=
 =?us-ascii?Q?ZmO5i/hUbKLM+LOlA++zr4ONvO0Ya9OoevhTA9DKUQI4IQ95zwOfgNGBbgym?=
 =?us-ascii?Q?aOl9YWinEB0GEcFFN0OzeriHxuDXDnaLrVUdSeiTNbE2m0J/CGclGg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l3zbtkP3BsbOOKKtiJa9YeguIVgSCeLoUxWNvkJevMKyT++dKeVIRKH3AtFA?=
 =?us-ascii?Q?PBVUlLDsq82pFNeo5Y2O6JZKqZVEbO+cbEmF2SRZW9PW2zpTpUQ66WxklDcm?=
 =?us-ascii?Q?ouL6rBuyZLp/AWsJVcgMDqsGf1CFpw8m2KcQkZt1g5+TRRgyo/dHrurI1XTo?=
 =?us-ascii?Q?eACA1zlPpbdsqwWTaIjLJUvLE6oobQd43Z1zrTP0MgDqGIFx7FBgBmMfbo9c?=
 =?us-ascii?Q?01GHqcy8ckXEDs8WQErsV17uqW3v3RwK0EHyNe3B+f5eNf8aqQiKZ1JKxy7r?=
 =?us-ascii?Q?CbnBQFMz24zXBzVD4ZZX7TcGcpliSGhQMa+Fd3VN8vXQUm7aQjTEX2J/adPl?=
 =?us-ascii?Q?fimr5LgzjnOL0uy5N1A5GrZpVcAgjys0BRKwfNf8pglyUU6uhJ709d//8a+A?=
 =?us-ascii?Q?GtDz6LCXYoBeU+DZ+fFNxxjrtd6jaFIszE8zH+AbY6tAs1WJAWjDZxG2yOxu?=
 =?us-ascii?Q?TnIHxnjb3BAcBDz+CfWED8QBPL74b0cU/D2Y3ouSe34GKuca0YRCn67X1Thk?=
 =?us-ascii?Q?ljBrcQoro6E+rj4e5afCpcL/H7czD7is7KhbFZQRrV8bbtQr8YmgU4rR5ULc?=
 =?us-ascii?Q?NPqudEPsuRTuU8FczIn433X/Bz0riXfbzJlztxZxlhFPOinkRsg2nrDt/Fj2?=
 =?us-ascii?Q?xIMKIdgGpCqGwpQfx30Am4JzrxTOTofqVVtJK1WYGMDsxT94Lxh1STcXksrM?=
 =?us-ascii?Q?G7qSp+szcp8FdE9VEonSWaEF1pwP+fSK0mizSi643GlPHG6mfMHM5WNV40YT?=
 =?us-ascii?Q?5zsnirHytSUqVXaDTA6VTDB4Cu0KV4WNZKlU10znvoQUUsqnEtvM9Hl6BCS5?=
 =?us-ascii?Q?1r2WD1DZYeUr/iC3i48Z2/DgcfQG1SKmv+DK2DPObhlil+JBhZaoAKGei5ec?=
 =?us-ascii?Q?dQrZgexQXRJbJY1U+4MGG5BO9t3czCIYuQ3Py7DLYb20mqbwrBkQyr6W24GJ?=
 =?us-ascii?Q?Ly2bM4sSFwzjMiZwzpyrxXJ6LosNAXB9tFxvEEQkPeQ36ZHwZdLnsbm8QTUq?=
 =?us-ascii?Q?66GThKung/3SzrpY+NFMAiUUM9UOBUcCJWhgTdRRuK4g8zJYMX0Vap72BVn4?=
 =?us-ascii?Q?Aqujbas7THrE8mB4IWBnNYE1NAQ5E61l7Fdkiazyn/iGXgGAvCUb43gdKsKW?=
 =?us-ascii?Q?Ik4zcMm7y/Nd1x4j9zIRCMYgRlFUMXQF1TrK2NWupxTiBLorrQ4YAE11376/?=
 =?us-ascii?Q?xGCcRrRWCmaXoICt6wQVej6ekTRJw8BhKyi55lbHUrChtPR1ksi1wg9PdNZk?=
 =?us-ascii?Q?scMLM4b86t/9rVdUpPpgaTI52XiCJqG+1lwgR2ksy3AphLqitdsObSN4Zfps?=
 =?us-ascii?Q?3woOUtQh5gHeOU9TweZKZ10rnWuo0GyRmH4+jN975+C4pXqV0WkhzmgUgI+s?=
 =?us-ascii?Q?ZN36H5h5lDA3kwblDrb5TDcPTncGh5oT0whBAq9C94lN+gH/V81ou4PNx9TD?=
 =?us-ascii?Q?t5GxsFO2YbUO8cbtwb+D+k3QtuYFYeLpih1XAGosg/CxRMRBe7LS0m0Hmc8+?=
 =?us-ascii?Q?klaLpNX6fmIXz2xhydqcccILbIuYNN7IoQ3KxYyy41+u7H0ee4dcCBzcEQKg?=
 =?us-ascii?Q?/tsJCmiYGEuuaprpcPWQoU1PzWmbqJJpECwyk+xr?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8138b589-c951-44fb-19c2-08ddd8d005b3
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:10:11.9362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PY4HWixTV+pBeJWqbWlv2BqC/XiPD7+ze/j9DQc1U5pQbh1XSZr4gw7nSSElK/AYh3iM8yn9iDIIAOZrZcTzzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF93F545ADF

Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
allocation and overflow prevention.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/bcachefs/btree_key_cache.c    | 2 +-
 fs/bcachefs/btree_trans_commit.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 4890cbc88e7c..8dd70024e513 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -136,7 +136,7 @@ static struct bkey_cached *__bkey_cached_alloc(unsigned key_u64s, gfp_t gfp)
 	struct bkey_cached *ck = kmem_cache_zalloc(bch2_key_cache, gfp);
 	if (unlikely(!ck))
 		return NULL;
-	ck->k = kmalloc(key_u64s * sizeof(u64), gfp);
+	ck->k = kmalloc_array(key_u64s, sizeof(u64), gfp);
 	if (unlikely(!ck->k)) {
 		kmem_cache_free(bch2_key_cache, ck);
 		return NULL;
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 4d58bdb233e9..4102a3cb2410 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -396,7 +396,7 @@ btree_key_can_insert_cached_slowpath(struct btree_trans *trans, unsigned flags,
 	bch2_trans_unlock_updates_write(trans);
 	bch2_trans_unlock(trans);
 
-	new_k = kmalloc(new_u64s * sizeof(u64), GFP_KERNEL);
+	new_k = kmalloc_array(new_u64s, sizeof(u64), GFP_KERNEL);
 	if (!new_k) {
 		struct bch_fs *c = trans->c;
 		bch_err(c, "error allocating memory for key cache key, btree %s u64s %u",
-- 
2.34.1

