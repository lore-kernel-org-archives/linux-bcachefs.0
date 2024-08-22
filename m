Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2051.outbound.protection.outlook.com [40.107.117.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C660B558BB;
	Thu, 22 Aug 2024 02:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295488; cv=fail; b=FlCCvf5Q7tCi8sNHq7id9vPJgwitakxRpO/uMmA69KcwwCVtLrxHRYSBXjvPfhPDE4uQilQJ8T9nvMiQJUzErRPZ6Z9jbAXZVi24Lt1YlVH23QgfyspdmMk+fC5H7oNoYnRlx4hGvEtm8+FjOn2MKy+MwI2M2RmZdKJNzFdh3uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295488; c=relaxed/simple;
	bh=iotJW+4NpJY1XFgYO0Zhl0U7RHvn7Uc8KMaxkorCz1k=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JXaz3b5f9mD7lcBYHg9CmjP9iGRTG2NuhrcbxJjfhAdIUKDeilSHJNR5abmFyBW/DURCBwjhyl9vXzzElbCc6rkYoIertRGrOg+Do1dtqQKP00CRq6bYRNUJzNqENUkHomNdGhsrkB30gz9n0Q+utJXaJ3yIKoIFQkJC8GULx7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=XdgYnRp4; arc=fail smtp.client-ip=40.107.117.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="XdgYnRp4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wjD/Nbt/JyASiGJS8dqlnpgjcOPQJ0Vh8eHROTtqyrq96T2yIF5hLkEBRZJ4bfVlLO8Tk0l+8iAYFEwHYUA7vW1cZzCLGLYjU21pY3b9/bzg+r0U6O35kvjFAGlIB9OMi0Q3K7Q35CPOSlRvPY8Vt9zwZ0IDWRk5qOsbSFm8OKo+sa5XRSbnm8vF3nu1dUyrMV/zhiYSflahCzzIWLB+hZOjH3mhb8+750PLXEIAl+1OjFLLVDaPPv5xT4uwIhs/2K327og+2c0iOGeys2+H/JcarFzTnogCU9aYVVxuQYl46RyUEsdpoirk3a7uLbX6OR+5J0mm58M8OeeN79AwTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KxLOalht2J+m7HvN4oDVwKjt27Tw14ExCM8SBu1uq8=;
 b=eGNWu6hBUvpxnKQ/KjOR7LjL0821r5mmU2kV9aFteDI2U0V04t62NKEXzz0RbfxsDHLOLDvLvtFKPIRqhFG6l5XDMy2FqLCHd6tO7e1Y7M84JToK7ms/vfh837Rk+r0LbMNAnPVJIcwQbRklAMp29OKzdnNFyElRerBrNdUijerYwF+Vf1Dh4YQ4J0b1ww7jVjKzzDFB3bbKQY8UC8looWAHMpE66PVtXxnF7etnbU612o5SXFNQE4UFPl/k+0Z5D7EGRujydIzIhpnbagzxyCqgfm5kwXTy7c7CzSumeYBGUMUylrAbh1vxmE03xQb3dYJ4Rs/k/2xXlLM4Dp+5/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KxLOalht2J+m7HvN4oDVwKjt27Tw14ExCM8SBu1uq8=;
 b=XdgYnRp42C0UqEP9qZoCNNxDdQVSf1GHLwH8CVWdPNq4ldmZhofKvByjMcyBhFDixL8U7eUlzpwA5vzxr6HTl2pW73psxjvu/dntQ4y0DmjI5y2NPFtVp3iJBTFyhEaouhApUglVSJdmZ2G58X4Elem3uYHtNcK3p8Gs9v/42Wlv7+o3CDtj2caoR4NwiDwkGeVCoCbZXICNwPvJOLRX/NbUUnxr6wDgzJ2NTeENtEt+z+yFtvzMWABIUHElqOpYdqEZaD2yrVj8772utvmgIlwdPhYnJypM139+bNkxT7+DVNMxuAhaPdboMHtCh1CfDZs3+/znZiN39tSc4GcFsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by TYZPR06MB7144.apcprd06.prod.outlook.com
 (2603:1096:405:b3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 22 Aug
 2024 02:58:02 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 02:58:02 +0000
From: Chen Yufan <chenyufan@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Chen Yufan <chenyufan@vivo.com>
Subject: [PATCH v1] bcachefs: Convert to use jiffies macros
Date: Thu, 22 Aug 2024 10:57:31 +0800
Message-Id: <20240822025731.5651-1-chenyufan@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To KL1PR0601MB5487.apcprd06.prod.outlook.com (2603:1096:820:bf::14)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB5487:EE_|TYZPR06MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: 247d76d9-ba1b-4a71-cdcf-08dcc2563cd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zY5FHDNiF1f4CfMVwCgoavsLI+e5hmUXx3pnUk5M1yqryT8+23vjiiDuFbn5?=
 =?us-ascii?Q?cLFgxpu0KsmQH2PMnj7r8dmbUDlxcVmR6OkE9PNFcwU5hArzrp88s1z3gjN3?=
 =?us-ascii?Q?LbprnuKdNksSzmnLweTF4zIhpTd2Rn3PSFzhDevTfenzU0asXyETeTejLvY8?=
 =?us-ascii?Q?2tJrhwaaGluYplDUDJ0WDrLOuP67unqGFNZDAFOLmEqOmh0+npgpuZKD5yOz?=
 =?us-ascii?Q?iivcZPMTFjZO7IRdHvRRsO+1OwxatkH0qFG73sWArR/skmV58qfc3j3ryUDw?=
 =?us-ascii?Q?p9Eio9mOZau8n5hPHVfx/bWOeR6LuF9JLiYZsHF/t6jQWcXRLnMhMt2CVJVw?=
 =?us-ascii?Q?FW1yTmZsrvjtU7qv39wFtjZ6db/hUmeTsVALii0D3kLRMyzhqawGkYwRdmx6?=
 =?us-ascii?Q?H7owBwD+U1HFtC9ChIOf5dwsEtrWtlkuVS9oOJ8WtX9iIXoJvLK+3WhFMjpb?=
 =?us-ascii?Q?S3bT1eNjsMZmumx/cltM3epVkUC50fpAlWpzxyq9xOiYzrQNvwlKYzviZipl?=
 =?us-ascii?Q?n8O/hH3lYAkX00B8rStYknOhjMXariWp1ZJGL2MgM566WLRZ798pSrvlcjFh?=
 =?us-ascii?Q?98PSgVgPZjVPIftdS7v8h3kJCzl61miR5YxFG+gu7ngkQNBwhG0coeb/duSI?=
 =?us-ascii?Q?/A3+y5x4EJhsEgwo66bH0D5TpH+K/Cn5o1h1xTbLTAfMDDglCLNzqa9ztKdu?=
 =?us-ascii?Q?v1xWU4wmHumVUJwKjpNJ+tLdvKco51Rf3FxJfEnZNdLFvKyyZMo9ECkdMxkA?=
 =?us-ascii?Q?H4ogNqg6u1/zNHon/PIcXnyyu3wH6KV7AzdbUtU/9cbgdrpQPrh6VbAhW2uk?=
 =?us-ascii?Q?dz7pGLu98g2Enx21wxONC8E/YSAu5iYs43kZ69x0u6KKJoLil29VjNobJ9cg?=
 =?us-ascii?Q?T8d5+BIDKgxUd6obOp5d3jzUonD1j0+YhOhBkkYggORPmMT06AydHbRQRD7i?=
 =?us-ascii?Q?3bo6rmcIBdRZgcspW2UOLAIg0f2hPcWTe4/BRz8qIpkIFFYzRM0AaUtcLLpQ?=
 =?us-ascii?Q?FbSYEav+48K7rhfxvxZjgRbA5wGjWmOnmGLBNEtonnZ9dcXhPAhnSoXqtDOw?=
 =?us-ascii?Q?YA0GM+FSM8thZ2YHrFlGE/rkDktEmw79rUBZlfvNR/vAFD3V+9cp8H5fRjYy?=
 =?us-ascii?Q?3rfpFmbXcLVcfMukVrlimCX5hhIl9274IOYJNpTWUhq+iaqTM5RjGb+6NtMN?=
 =?us-ascii?Q?W9F9x6+4ZVTXGOKKC0Kdv/8Mh1cV8hNLxGXAZRH0Efj8g9AOsVgSAh33WqA2?=
 =?us-ascii?Q?SVRHX2OP5DkZ4/nhpsVBMghZ7NCaszXJqfc+QN+510wLYsoRqO2BMEEbmZ0M?=
 =?us-ascii?Q?/RDYIFaos9sJT+NOILQlDpw4B6d+NYzjiH8UCgaCeiiZkVl4tHqzBh7yaLSL?=
 =?us-ascii?Q?nSSO9KY8fk+KEQq7FxogB+SG5Wp91MPOFJee8SZQetHsLI+AnA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yrr8PDVReKh65yIEbjbbHSpouwOLfAG6H3tyRMGULE9ancauNuIFr2S0kfFD?=
 =?us-ascii?Q?dRqi2Pj4gT06tK2eTL2bJwLf7QGgS2SA7rA7HLl/iKcCL6FpkKx2/oGJOH3p?=
 =?us-ascii?Q?uYX6cygF7snlYbmT77aCHRs2MEYURJyCC92gW0JX4KO32OMeDVGTUiqwg3Oi?=
 =?us-ascii?Q?MoolM5yHRHr6T/TvROgVI6H0w3SEZPjp/UVY46ZP6Iu7dylyJCm7/iskQXXb?=
 =?us-ascii?Q?OzgVog3rhrHp3LP2UbqHoe+OQUWfVrbaUXHf7TLpp1b9jnsZrn0vtAONZNgb?=
 =?us-ascii?Q?Q5m4TqcQ74KATqLoG/2bKRPKCye9DbBuOp2j6oY/UorSvmZ4Q8S/0qnolZb1?=
 =?us-ascii?Q?y10x+3d5tpkV84gBAk9tjEtvbG72AMFr/xRIp6L+2n2Foyw3w97B5+Q+Mg8I?=
 =?us-ascii?Q?W56FWhLyomvYTaOI3Nbp9hfRSS7y5PNsY/lmXQeDewxigQuoflO1Al1Bhek9?=
 =?us-ascii?Q?rrAis5EOp80qvBviZ0AV0fUezfUdv2oQ/ZgWqmxT2lY6Wv3OZsvNeotMPpp3?=
 =?us-ascii?Q?1CY+In9ZnHmSjsepg5OLsLnLmiQVIxXAkCLSIU3Lv0vGk4oMax8aXSyoDbId?=
 =?us-ascii?Q?KXhStt+6UL2+HmIZpgejSHDT81+G/NX6ClbAYvQ+m6XyI7odyMzR3zM2Wqr1?=
 =?us-ascii?Q?O4BcgiOpBNt0H5zgJkPxkm0WDArZMdiKq2h8PS2IL2GDIbJDWuvyUeIKXnSG?=
 =?us-ascii?Q?FkIEJk3ESIreEgpBisnVuYT9b/FQt2wW9QwsIK1OQ/11U8Hf/AACa3853Kdu?=
 =?us-ascii?Q?w1mev6TQA3XPCtF1/DE5q8URLsrHv0W2W1B5aEjjNy03RdmsPg+soFfAdqdI?=
 =?us-ascii?Q?dyUtAg1km5Dav+lyOqH6mC9h5DZeCw2Afiez02pCAwa2GaNbBdH7hmT0ZjAk?=
 =?us-ascii?Q?lQeB2tDyk3JGImswEznKJ9MuoCgBRDKhN76YHt9HttXVhIxmCuZ86rEeN9iE?=
 =?us-ascii?Q?aPS/BP85WvtulND2gcO0a5dJewuO1gvdtME7yazGHSHgwb4+9NUtrdXv/9rG?=
 =?us-ascii?Q?lS4T1mqX/kcdasY2e6/dDmvoZNmI3KQHUtBL9EePB6ifLXovKkyO+fHW7z3a?=
 =?us-ascii?Q?TYwCRyGvg8gC0AphkeSQsXowhW3tukt2jbRa2D71/RIduKuL/Xk99hfX11LL?=
 =?us-ascii?Q?4QWEoukbbMtMgUdSJjC7MhLVWbFfwHpUkCXfWkcmqL1JecVR4n8ceVqN1Ul+?=
 =?us-ascii?Q?TU+MBaN1LTqku9R11D8PcOZ363wHsfXZs2QZeTKLuxd/O52qRHz47VPiPydd?=
 =?us-ascii?Q?Fx6dK30DLWIc/6+v5tpHPZvxrKVyf5KaMD2BYyid7xkjQDqAKSc3asQIyCTV?=
 =?us-ascii?Q?gD5lXwxemJP/JEb9de5jy18no+Y/u33nPXPLVcV78YBGZzCkisslmajr0kKs?=
 =?us-ascii?Q?G/E/aPe5lT9a9drPt42hRtv6Wf7vnH/Lez3lihVAIlMkjbf8fW9uBMG6qngl?=
 =?us-ascii?Q?iJTC9FnUkJ/zuILAbgCr0topphpHpmTLyYL1n+sfyOFHspwULGmimRLnK3N9?=
 =?us-ascii?Q?1DiubxVlPs0dvMXcQ6j6ooevMmWY4A6M19jBbOy5DiafFg+XBSMrM1Mi4MaM?=
 =?us-ascii?Q?kQ1G8QDJ2vLudVnEcAcdMRq+cd5qr1gCxJrIjeDp?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247d76d9-ba1b-4a71-cdcf-08dcc2563cd6
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 02:58:02.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6kgH6P3aE0ZqQu9gsuk1bMdyIZIXl2iR9yQhgSl7n2GcqzAP3DxsCC6ef4F7YDQfjNdSMliOuCarXIL10afEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7144

Use jiffies macros instead of using jiffies directly to handle wraparound.

Signed-off-by: Chen Yufan <chenyufan@vivo.com>
---
 fs/bcachefs/alloc_background.c | 3 ++-
 fs/bcachefs/journal_io.c       | 3 ++-
 fs/bcachefs/thread_with_file.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index ac933142a..795539556 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -30,6 +30,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched/task.h>
 #include <linux/sort.h>
+#include <linux/jiffies.h>
 
 static void bch2_discard_one_bucket_fast(struct bch_dev *, u64);
 
@@ -2181,7 +2182,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
 	 * freespace/need_discard/need_gc_gens btrees as needed:
 	 */
 	while (1) {
-		if (last_updated + HZ * 10 < jiffies) {
+		if (time_after(jiffies, last_updated + HZ * 10)) {
 			bch_info(ca, "%s: currently at %llu/%llu",
 				 __func__, iter.pos.offset, ca->mi.nbuckets);
 			last_updated = jiffies;
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 7664b68e6..32b886feb 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1950,7 +1950,8 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
 	if (error ||
 	    w->noflush ||
 	    (!w->must_flush &&
-	     (jiffies - j->last_flush_write) < msecs_to_jiffies(c->opts.journal_flush_delay) &&
+	     time_before(jiffies, j->last_flush_write +
+		 msecs_to_jiffies(c->opts.journal_flush_delay)) &&
 	     test_bit(JOURNAL_may_skip_flush, &j->flags))) {
 		w->noflush = true;
 		SET_JSET_NO_FLUSH(w->data, true);
diff --git a/fs/bcachefs/thread_with_file.c b/fs/bcachefs/thread_with_file.c
index 0807ce9b1..fb3442a7c 100644
--- a/fs/bcachefs/thread_with_file.c
+++ b/fs/bcachefs/thread_with_file.c
@@ -387,7 +387,7 @@ int bch2_stdio_redirect_readline_timeout(struct stdio_redirect *stdio,
 	seen = buf->buf.nr;
 	char *n = memchr(buf->buf.data, '\n', seen);
 
-	if (!n && timeout != MAX_SCHEDULE_TIMEOUT && jiffies >= until) {
+	if (!n && timeout != MAX_SCHEDULE_TIMEOUT && time_after_eq(jiffies, until)) {
 		spin_unlock(&buf->lock);
 		return -ETIME;
 	}
-- 
2.39.0

