Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013049.outbound.protection.outlook.com [52.101.127.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C4A94A;
	Thu, 31 Jul 2025 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753967779; cv=fail; b=IFSHM8VHSXedSLrW2zS8KnQD7XaBhu9X7sGpYPqcixkZQsgQ0Jx/Q7I76oNLZ3Hz+En/CmKq22YPD2fb+ZkZDLEb1gv3hELHG6KZKSZyJq5D6fGpF3b8yEBPomURf5xCOgM0ako6qHqKeEjM/RLdz+zKsb8gGW10hVoXgTaa/FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753967779; c=relaxed/simple;
	bh=NIRQXU0ke0RH2HgYw/qlGL+rGg8+QuRZl4APevMDPSU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SLB2jmsZj1zYPadjCqnANrYJiht9rUISGq16kykerot6/Ai0nv95Cpn5XweBYCgSaKkWfCOvYElhujJpDkeKRUmLIWRwBc0u/7idvKcJmf5TOiA83fIbz7NmMTi/IQAiyICN9ktBtNs5+wMI9ncv+Pc6fTttzFYrEaghCAtX9+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=oiGrHqdM; arc=fail smtp.client-ip=52.101.127.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="oiGrHqdM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekCpl+434AHsjQfcQzV27iwjWUvjC+0TUUO9awDWp++LSphmcCIxjV/d0mAHjHZLOFapB1Y7JuqOd/J1SvbOpZNvNsyEimzNa9cf1GCCnncj0o7VLAavmakfm4DUmEvthZjFy0O+VVrnxWezuN794GsRBbqhpq6f6fbVzOoHdw7n1mtcrsVl6sn85yQtmVOtsYFG9Mh+RDZ4CcoECd3Nkf1AZxiGbCzVV5Rzi1uppPTMZiAA3xGWtG+L8sGcaA1ke6XalzuOqQOYxtMCfkk3aObrgx5or8Up/uaX8slzQ5Z0GnoNrScNwm0mukg5py2G/Q7oOSWwRWcMhBwzC91uGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2s6qYzpj4cVToIozm7XxHs3sxALm2sk9e+tfJB1qwP8=;
 b=fiRy3NxNEUVUtqaWCriGDtIW8iatzkJ/I85xwubA5zK49DXUqIurxA0Uwsy0KW1YDUIT56SRBP0DgRJPlieD5TBsyHvnJVphmZFu+6DvOS8/AMte/nbSsQz8QJV+Mi0W9MJRRzhKwC1bstJJtjtV5X6qtySVnX6I7opmaCMnR/dq4vGP7oRjoaizPl7paDNYSC7lNp4rxaA2M/m03/+agDN0qW5rFs3utFb+Cz4++DzQ0oTCy/T7O+y2sVPq8KtJUGbicsmQ0NHLnicj36puK0ECzCuKYJlTxdD+E7bv69qkmUnNyNr/AvhyZ8dE+XVWwqYmDLQZiSJl1c0c2CCwhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2s6qYzpj4cVToIozm7XxHs3sxALm2sk9e+tfJB1qwP8=;
 b=oiGrHqdMzsjO2JYVvTdfrFQyeCwc6spknY6AJSpvoBMHTyceKMloVLYQX71gVL3GBG9zfJjWF1tqqFupWsp4xylyNzGFM0jtxDL/ND+uB1eTkYgom2iKu4jKdDM680dlbg3t90GUQO8uBu2JTWQZIFQT3HxRgKhoErKYeLcg5EGxH4SsIa1zusqUli+m1jEkz8+JbR7F3fxm4LJDSlpnXuHEDTQmmCtj6ZGUqjREGPcDGK4xMEO7SAwvH2RfoyjNMugyAIWA2kcXBAPwRyEXfD6vq7jtqsAmAI6e3OTiiGuIworMOQNr5Irv39sDrFo0R1Efj1Q8oS/BmtrLg47vPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by PS1PPFB8AF4A12F.apcprd06.prod.outlook.com (2603:1096:308::261) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Thu, 31 Jul
 2025 13:16:12 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 13:16:12 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liaoyuanhong@vivo.com
Subject: [PATCH] bcachefs: Simplify kzalloc usage
Date: Thu, 31 Jul 2025 21:15:51 +0800
Message-Id: <20250731131551.218666-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|PS1PPFB8AF4A12F:EE_
X-MS-Office365-Filtering-Correlation-Id: edc9e250-0e7a-42e3-a762-08ddd0346bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1VyZhbve/Q87eFieupBLldlpxp461P/kUOrC4JFOoXTwc+oOaH9h4df0OLfs?=
 =?us-ascii?Q?0Lx5wxSy028+huzRis9F5VTdUNxzVqrtbnS/j91ZohhFlfgy4AK+mAY9XE/c?=
 =?us-ascii?Q?VyC8LEVe63Msn/OWYfRLzMVTWYbkhg9oqA1Iotpd1+SVdJRZ+UDw3YAkZcyR?=
 =?us-ascii?Q?EdQVuu7bR8B2KUUHQzOJtvdGJ2UnpYjz3z57wfYKZm/4Zpt4PrSOr8EqrVGH?=
 =?us-ascii?Q?tsiZ8u2bOXe7SmiQooPXcDyUaqMDzG+XJLJQbvzD+oNPsXmYXOFl7S0a0anS?=
 =?us-ascii?Q?K1EiHzUMgHopLcfSpUKG54Wn1XJruvT9NuNy3ZIdxWwcAyZJJQ7W4ViGDsND?=
 =?us-ascii?Q?g0UC6X8OKmT2H4dwi7HYxeaJNQyKpYv7Bp0xQZZ802K2Q7SH9rc9kUD4jUiZ?=
 =?us-ascii?Q?MYSeSzFu+SxlGelglCHabaljnCm4w1OWQl/2z2T3yq7MrscH7gWasVoJA0sa?=
 =?us-ascii?Q?AxGolkb/2U2LkIYOB3K6d32tk8Gww+80EDWyzFfTdoNHZgkhGw/PaT4BcJMy?=
 =?us-ascii?Q?9uXiA34ehKMbtA6rWhkpADypDRUQqmZklVfC70yeP8/b6LcpnvQ7aK3XX09m?=
 =?us-ascii?Q?0FqX/+FLbBypWxTzf0oR4w56RZQXaV10HWIDmh8d6jnF4jVRFJFA5bxwn6E+?=
 =?us-ascii?Q?PyEFnT/VtWa0T5VfjEt+4XoXhkxx7a8hr8s8KQwKTkc08qSh+6mA+vlkA6hr?=
 =?us-ascii?Q?ORSgu83qfDNJ1TImVZU7AzoK5r4zzP6CsR3QOQO4CfFy8YATtTBcJ8Msqt/a?=
 =?us-ascii?Q?HjVV4qXjDX1WasSsw27hsmOgim7fRKPL4H/5jSZZ+nVKjamER/XzYzStuW6d?=
 =?us-ascii?Q?Tq1V8BuY1gVCmiscC+svndgK8HunW/vx08LE8O5SBBzNSemu9t18NBhihPSF?=
 =?us-ascii?Q?NyZZx60+G/V1wK2ng0SZwG+m+Nn9mz/7RRgHBN+XB6vG+fy9EQiW8JxbVEOH?=
 =?us-ascii?Q?DZRSG25uvkbekWHXhminBDqBdhW0A9MZIv0kp0RpYf/T1XGZHEjj2eI9kbfd?=
 =?us-ascii?Q?0YqHN+T6wBm6+hVk9BX9II5iVnm6dQEOJi/MyFV3jNEgAX9BJLnKx7/jtUeu?=
 =?us-ascii?Q?yT3XceET6sbS+XTtWaED8PvmR4QocdtVsTFKy/yfOuQuEd7M1TzVHjidfxjK?=
 =?us-ascii?Q?PRm9o1ca8svov5YLop17bh8kcpjs8FZdd39rXA3ja1/Roht+/Pw5EfBEVRki?=
 =?us-ascii?Q?aDXFCsy61rFSe3neqnHbX6LAaD33t03dE4KztVInbGtEHZ7tHHxeTo6u075K?=
 =?us-ascii?Q?Uwjds8hXfJ0Lw0sc+kJMa1QspEMXSe/Snmrsolm/YdEhWRjN5dIZOEIfJhGw?=
 =?us-ascii?Q?4T/3Imj+KeW09ZOteHgxjnQ+mpmoHzL0tClu9I6t5YZt3p8juAjdM6hFjdia?=
 =?us-ascii?Q?cHEaGxNwhrdXS6sZFFyW6RUCgFuDJ9nv8UHySwq5e+yyPsAFr/DDtIrSXHQL?=
 =?us-ascii?Q?t14y4rYFLrQRK1vfEvBDnnBTzrNkjX84cJf7LfNPLm6MuPc7L/+czQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cpXP71hO14GEdqKJn65SkasUy7dKGaTsV11MXYFkfrSjHR/H0OoEQnRPLjZl?=
 =?us-ascii?Q?mOno6DGa76Mx6ngWb9QptcH17r4INSpIxvFds4NtF3NProSMKyHJ5v/zyPvt?=
 =?us-ascii?Q?GBuVPhghvFhraD8eBkpDc7OtXN8X6Ioc8B162oAanBHrAYeibvxUeDHFTZVt?=
 =?us-ascii?Q?1uU+g1HMarxF1OH51aL0omydvXJHIm42p4G+ZN5TbobQiwT7++mZH7QUdgtz?=
 =?us-ascii?Q?XfgsFw8qloGX4bm/Hs5PREDssq2N1meZkN1h+FujPFGAW3ACeH/4c2cXMj14?=
 =?us-ascii?Q?dNVGcZnPTTSLltbzAhe7yVJGr6NCFUFgBHlSnirLA3KW2EaKVN9KcQcnTRRO?=
 =?us-ascii?Q?R+DP+nwVVRHM8lSNnCHtbEVRozPx/g+riQ3PNn7kCepHzZWf1I/OzxlkeQ2Y?=
 =?us-ascii?Q?FNC4j9PSPdB7by/zQefjGk0qi8wZdv2giPA38bvISJfwSk19djR55rzStNPn?=
 =?us-ascii?Q?uternYq+ESVgh+ZB0znLTF0dsKjuqqOtrMOEPfPgiol5oN9P4mM4H2hvItkU?=
 =?us-ascii?Q?gOdZBqt/YcsYfkZwTL5jmIkhihWVEKqoRloiLjh9HYbZlN2pV23RTxJhxAz0?=
 =?us-ascii?Q?+kLyzY9UraXMdCXIHjg5gx05s1f9+JrQKqR1/s7tdB0j0kBzePMZlq/8Gnza?=
 =?us-ascii?Q?d6VssO+V8zgQPL9i++lcTxFxcJMUMgHupJ3sVV5aQdI8glDe/2wtF8dvZOhA?=
 =?us-ascii?Q?i1/KX4lxcokhO6KYBhzJ174GypRWP/VYoHJjkpidvxHkA1F1mk9oXgu9bsQ9?=
 =?us-ascii?Q?j7nOek5tqtYn29ImvX0dYsK9qKmXVYeMRQC+U0XpB0c0FruaF+jlh8mAur7y?=
 =?us-ascii?Q?ocyZufM5Qv0PSO5wrBuOt+CBkFSxMaD2hXvb3VL8qHWp7oGnCeroAVwyBsTt?=
 =?us-ascii?Q?VHLwf3qBRcThV4Nq9MwxATsIRMdN1+ji8siJdR59g06cueGHb4xWWlyJq7O/?=
 =?us-ascii?Q?ATzwpMWfAyKc8IL2xS3AlR0fHnlVmtHqQkmtJKJXdTf1vKh3z2KXCVYly4kz?=
 =?us-ascii?Q?8wrZLDT6uNf22Ej0VkTkJNi1lX1gaJHCTkNFqz1Pu6oDiwvJHhBI3f4x3aRX?=
 =?us-ascii?Q?8zgsmMieEIkvOTh0Wn09JCQ7RYLgjPenQDGBjRX53OHXs4Cw2VpCBQf6a6Jv?=
 =?us-ascii?Q?jIBLDtXCGL4MFWsfE/RegyfdIpOsPiS7wTrms6wLjfNO7NHnrfwmjIHms1ba?=
 =?us-ascii?Q?STzFFHBobx66wYD5xpSlAmYQ9tDoYp8tC5czMREpkD17mp6lc/OOv/9iaWKs?=
 =?us-ascii?Q?yhyoAeveGIgUHSLhduHLLV+Nm1YP3UR1xz3L6hE7aHTUOHhsn8WSaTBg9wkJ?=
 =?us-ascii?Q?VroI78UQ21dQxPSwYZa5MMOtwEllYXRKeGO6eEe4iMshkoOGv9weVTAPtYLx?=
 =?us-ascii?Q?WTikhpdwaH0vCaGJR0J7Z9NmMsAnxilickz9yFQRusJnknzcAkzGTLIAgsLq?=
 =?us-ascii?Q?qOgoeFd/+O+Beqv3l03ObqL0TRHXJXn5uAaYmHQS/PLt8c3Uyh2BD9IITI9u?=
 =?us-ascii?Q?4RJtc4QOLhqNuN77xrWZuP/luHZ0Y0wqKGqcSJy1vFd0RwIuPhcsnm9ADJF4?=
 =?us-ascii?Q?mIwVfooEo2sZEBtO3B0qIGS1vFcsX4etiVIT0cN0?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc9e250-0e7a-42e3-a762-08ddd0346bb1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 13:16:12.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49ntMAfC2EZbZkiIfU3WBS8SgR0HJ+kcKCAQT09Kl68MQhuj3Pi0K43uKJPCOv+lU2wnKKVKxrIJwR43mJyVJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPFB8AF4A12F

Use the shorter variants will improves further maintainability. 
Convenient for subsequent code updates or refactoring.

In addition, there are some places in the code where variables
are simply named 'i', which can be confused with count variables
in loops and have low readability. Perhaps I can help gradually
standardize variable naming in the future.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/bcachefs/async_objs.c  | 2 +-
 fs/bcachefs/btree_cache.c | 2 +-
 fs/bcachefs/debug.c       | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/async_objs.c b/fs/bcachefs/async_objs.c
index a7cd1f0f0964..9fa09ac3f583 100644
--- a/fs/bcachefs/async_objs.c
+++ b/fs/bcachefs/async_objs.c
@@ -45,7 +45,7 @@ static int bch2_async_obj_list_open(struct inode *inode, struct file *file)
 	struct async_obj_list *list = inode->i_private;
 	struct dump_iter *i;
 
-	i = kzalloc(sizeof(struct dump_iter), GFP_KERNEL);
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
 	if (!i)
 		return -ENOMEM;
 
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 83c9860e6b82..d04ddf3072c1 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -173,7 +173,7 @@ static struct btree *__btree_node_mem_alloc(struct bch_fs *c, gfp_t gfp)
 {
 	struct btree *b;
 
-	b = kzalloc(sizeof(struct btree), gfp);
+	b = kzalloc(sizeof(*b), gfp);
 	if (!b)
 		return NULL;
 
diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index 07c2a0f73cc2..b056a37dbba4 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -335,7 +335,7 @@ static int bch2_dump_open(struct inode *inode, struct file *file)
 	struct btree_debug *bd = inode->i_private;
 	struct dump_iter *i;
 
-	i = kzalloc(sizeof(struct dump_iter), GFP_KERNEL);
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
 	if (!i)
 		return -ENOMEM;
 
@@ -721,7 +721,7 @@ static int btree_transaction_stats_open(struct inode *inode, struct file *file)
 	struct bch_fs *c = inode->i_private;
 	struct dump_iter *i;
 
-	i = kzalloc(sizeof(struct dump_iter), GFP_KERNEL);
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
 	if (!i)
 		return -ENOMEM;
 
-- 
2.34.1
