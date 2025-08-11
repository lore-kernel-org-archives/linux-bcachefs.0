Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012016.outbound.protection.outlook.com [40.107.75.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9EA2D3757;
	Mon, 11 Aug 2025 12:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754914216; cv=fail; b=Z0y+OGGXqZCeh3z12A9OXGKD/M91MQ4TKgdiV0sxz345few1t+FbvQHfw8CUlkNruhqpCF3JQpmyZv6zremTVGhP53e6Drg+kvbsF+dvPI9RJGVrBDtVgAMxQ5+KTGGzKYWQdHE6MWZKbfHaEH0Vk4HpeENZB/xV8encLFOESgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754914216; c=relaxed/simple;
	bh=RuJERuDI6ACg12BcS6zVz7DNPNW720VqIShltn1Ewvw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dP6MGA3ksMcxHfYcKlm5tAKAsYVZQDqxm/9EPd1IqgSe8WYtICTa2YjJUnFMBZ0r/hRIB4399D309VYaMrliqTru+uL1w6CLzBJsDMmmrIxXcV0UEdRG/v88Mr7mmmaesuJXFPcsiGWThDl6DmhwSYkb+7RdTwz2WowAQaPfPl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=U2mt0gBE; arc=fail smtp.client-ip=40.107.75.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="U2mt0gBE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pniFTTIQqJEhTnWOk0dbqcjcpRgVaTx06il+eCIxSXyGLTY5UtMtpgq237jTyZijaVQynWzq+XpRFfhgC5KaBlywHSYRwYacMm6ceA8/L+BTs+hms1hgjXvhLSINN3oGBUCI8FOWXabc8tHxQpb2Zfl2h7kwxfoS/zR8DFF/FjS3Px1VObuDWLC31r8P30uNj4K9Wbk8BP/R5pX2a/eEWpnxKN/98z7lGgHYYWjs13MMSv9HSCtmG4bidnvD7CjTqTPDoBNZCvuyzujOthL1dT8HTQWkKJPPnsocM5seDS+rHUGaTjKIDksKke9jrN7AahGQ2j8odU330iznOR8s1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1I8XSC1dGNn9Ie5r2YOG7jxodS1z7I8JhsjZwOiUECE=;
 b=WLcvM9jwvuhOO7j7uXzMtnz68iuZG8kcqRspavXwk5VL7MeTZFkcgWJQoiMU8FmcTTHErZPfDj5P15HB0onsoxlQIKEj8HAxOonEZOayxp4BzPy5y+JUKO3ji/JwsUSHrmtKm0umFdd2sawC1m+pQEpxS4+preiLE+cEac09b46T8t4g9zmoJog2fheJqNMBUKljMftJMSE9IpRjb+o9KjvhiJMZR6YsZkPMQC+XeYV/KVTqdB4pfrBhBSRoKuXItxrXgHoqZwU3QAFohPc/poob10nn62M/hEgM2Evq7ca4P5wyA/DC9tifGHmkpM7Oz6cEJWJQnMAX/g6GAEOLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1I8XSC1dGNn9Ie5r2YOG7jxodS1z7I8JhsjZwOiUECE=;
 b=U2mt0gBE/PKm5FN1rTjYyvI5r4pVaJUuwwm4Z3DppKJ2XUv6VBRR78TQysHv2AORQY2rl/FaMbiQG+kpDl78lgJsnCjhSWdBCyvZa1uofXzBeFPSQe3ZWgYAoFK0rOaUT4FYrO6J086HUKT5UxSu0Tjdmh1aVoS/MTrUFKCd5rZ2Qd7HnRJxXjf03tSAWs43ES93hAN7cBlru8mvFfMosy1D0tMuDsxUqnnaglf8AVBlhvlTfkwtzSOHqjPKegKjSCbTBn3UgD3/8tl16Fqw9nbFq7a/g9HpBc6w3d7Rrogbke+KF2KUA7DTJwQvb26fb2TGR46mbjCtvLXfpcdl7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY1PPF93F545ADF.apcprd06.prod.outlook.com (2603:1096:408::91d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 12:10:09 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:10:09 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 0/2] Cleanups and safer memory allocations
Date: Mon, 11 Aug 2025 20:09:50 +0800
Message-Id: <20250811120953.529864-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 153212ae-f03e-4569-23da-08ddd8d003c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R6bFRDU+k13N8tXDH8oQnyXww3WDovh53qmZUfy4OJZCuZ8ZO0raiJMbFFz2?=
 =?us-ascii?Q?LsiICE7f1mPPle/jIl23k+IZyo/uRvFrqm+M+AK8Ect6qwXq4l+YyOehajiJ?=
 =?us-ascii?Q?WqnDrA7PHCM0sxUNdKRh4+cqf/odAUCQNOZ2v5RwBF4TY9mhHPhqi01za0Ep?=
 =?us-ascii?Q?Ge78ayNzkoCBkC0mDWAh94l9Xs4cyQLyruSVQh5A/VKfpTkMtO68XtE+NcHL?=
 =?us-ascii?Q?kJd1fQqy9QJW8ZYBUZtlzcrG+63JHiQYNqmf3cU7mDYkuTt7uI3pGgFiZ8Un?=
 =?us-ascii?Q?EUo5TRN/GFbL+DwRAZj4wQ2LKnq3ToFagzhSY8IPDDN1B4ZEtZOoRfwALexm?=
 =?us-ascii?Q?5ynlAViVq98zLgOJqkqV9p2BjthqVqTOCpx6c/DZ0TajyVv/SI8hurFlIkMv?=
 =?us-ascii?Q?Viz98D6HDKlU9g8awjvLj77Yn/Sq5/aAGTtINMPlkrBQWVkxtH+PIe6L63hb?=
 =?us-ascii?Q?hHKPZEeyplpYAzccIFv5lKLAa77LKFb5bQu8MZ2ZOHg51wqgl/KjfbUsm/L0?=
 =?us-ascii?Q?JQ9nDrfuKWFR4m4HtW3B0pUnYrCXoDixfHsKJeYaxCQppKofbFvK5WzsRs6I?=
 =?us-ascii?Q?zqOBTkQOVnF2pIzUtZCCy5r7rzRv0UNOl2fcXnwAkXyDpZ6YDE0BUabTLWWH?=
 =?us-ascii?Q?hsqmEvVolPySkAT8RZvuYIwHVRoTj3Vsvm/MblwNchiaIBomD2q7b1wY6nNQ?=
 =?us-ascii?Q?SY7mcFN/Pfzefme07EmKmavxDJycbVXUs8TUy76vx/GAvccy0xWQ5xoQEQUl?=
 =?us-ascii?Q?deZjBkvN8al1m2cxM7t/AE2YM0SoSzO8DCZm+R74hAr0qb4n6jkiJ0YTOUIz?=
 =?us-ascii?Q?YrfSj/3tKVgRYcr4SB0U9uqug6yJRBhlkxcDyegXpNqzfVe+Q0pE1RLgFD8T?=
 =?us-ascii?Q?amIlqa4vBYOIyQG4qyIkHumwMYriqQj17zv2FhAOY3sxzq4SlCeunU6OaUQ8?=
 =?us-ascii?Q?8tMJb8qxlQ/FUpI0kZPcwcMhBf2eod41TZ3FfBdnYa+33hCn14bezVq8Cx0k?=
 =?us-ascii?Q?pUiyrAQeoOmfshJKwrzAzeziqs6AmJ05WesQ8v9DVk9kOuG2g5tXXrMpZdlf?=
 =?us-ascii?Q?+YYqIQRKvlbD1dI3/aS5+Sd9cmgapto16gk/K22zyjtQyxsoQbtEPJxM+O1B?=
 =?us-ascii?Q?WLNdsHW1rtsAzz/Dr34oEWQvPNEsXimGF4tjjtYu89gPSQJ+5z+M1uBscGcL?=
 =?us-ascii?Q?gNMI2HWrp6mid5THOO39d64KUSiWBCDYjWH4P68eCdsLDAT1NU8+ihy+fZdW?=
 =?us-ascii?Q?46c7yxrl5t9kTUc98RhoVmwLUef/UPcUhFTmNqwH6dpW3ohBoxjFB0FBapjH?=
 =?us-ascii?Q?9uNN1WbmGuBg4JNRctjkLGXPaz/eI2j+y13QxrvC+zjNujRzdcGLUUkuQldX?=
 =?us-ascii?Q?RYB5tNrx040t25GyBe6dcinSDgKBlJKtgDGwrVbII9SFBuCndO2G0Gk7HV9U?=
 =?us-ascii?Q?Sxtnis2Wrg+VHeZu07tI78u+KRBOWHscVicfrK132afRk3Vmckzh5A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sIYBOU5+RyZxSEf3zDoyE4Ov4O0r7Uzxlin8EZlaGRuIG3Qx60kPnV8vh9wV?=
 =?us-ascii?Q?9ehlAtz/8V1W/eiDKlX50w4xkJIZFLTtRrxdM5Dw/DmZOZ1pJBbkmK/7ueve?=
 =?us-ascii?Q?/1ULIRzCZ6TG9SOiLibyJu0/bb89nMyM22QDBCNi0P0IBT41IQj6uIu482tU?=
 =?us-ascii?Q?fm/MF+G0E9B0WQLRGSwOlbGxhDSkkd7N71wnKZ8Skva+Q0OQw/HPiExZF6sh?=
 =?us-ascii?Q?UDuqp+Ddm8gXKMRHW23+IkReobE7IjDGztrKfOxNbFX96p/RXbVoHhceHfca?=
 =?us-ascii?Q?csWwuD7c874CkbxMlWXBuh3ufp5nCIOPnTZKevp1SnyKYw+320ahqi2ItU6h?=
 =?us-ascii?Q?zsnohhUUghSQBxxDkpu31akvD86ZgWnehAj4oV9fpYfek+MgPWwRpqigwikU?=
 =?us-ascii?Q?i8ZHxrQzZVi68TdR3vn/7N92SiX1Q7btGErd/iVIkSGzTw55kFAXn1LquS+C?=
 =?us-ascii?Q?HacsApCpVSvCQjHy8/u3V60IFVZU4t+3s0MEF1hq2xRW6i6nDIloAcXJqJW7?=
 =?us-ascii?Q?g4j92RlO/GQfVKhre4byff5AGIxx421WLEA1XB6nh0+m5q5myfxhgU33jpyC?=
 =?us-ascii?Q?VzeqWPSKewQHBAcKlZAEJzuLDEl7xwaatxAAfHoVsEfZfpDdDbWJp8n7T+Bn?=
 =?us-ascii?Q?jIlVw6etYIyWogz+1FBduFS9mTcSpfEAgptLQZK4SIshUFeGgEhnLkSVNnJu?=
 =?us-ascii?Q?ei1BZ4pHJV8g7OBOpra0xGfFMXr5jL86+cLSJNfCZrAfBEIjMGfYM7/wJsG0?=
 =?us-ascii?Q?CUqAZ+tfIL7paIZfjYOdsqx6A/FMmNpTwzAbfESpeZ7+n5xz6EqLw6kDNUMj?=
 =?us-ascii?Q?MqQkj3WirGQfpKnKkOWOeGNMyFQMhaAHXi7cpizYnN1S07OqkHrh4mfDQWIe?=
 =?us-ascii?Q?/AR6MBGTAnb4mAfA96mUCje+qHUB0vrBwnI2IdgJBNx+y0R+hATC1YbYnpVn?=
 =?us-ascii?Q?EJx5i15b6SV9ulaC7B8uhOV4TW6cCGe3JXRoK9WC4qEuMmkl62RdWsHbBB+t?=
 =?us-ascii?Q?7fVWf4C/9PoX6H+yrrqbu3N/Arh4t5YFeFqT/tQ65Zi1o0zNArjqm6sSH2+e?=
 =?us-ascii?Q?JJLGbhVw+Iw7CqTJMHNkHs8Zpjiz+DbgrB4fj0qb1iS61aPE3OIOYU85Vsh3?=
 =?us-ascii?Q?OiEoYFum/NEQKkHW+OftMomuzyRwN2xRT9axXvxNmHkM8fQWYubPNIAFNFfh?=
 =?us-ascii?Q?RQbHjJ3cUvM6ZTx9MJxvtzG1P2PI58HFVCfznQWYKK7LKDLo/bVgqOQxbkj5?=
 =?us-ascii?Q?l0Qyzoh6Evts2n++REnuFoPaQmR97juLiBJEnZgrFr4bsTUauKh1zNOuuwPk?=
 =?us-ascii?Q?KbHtIPzyODsDendHiNK/XwDcS0foobm0d/rrPRtAIjvrgE8wzklESEtWcelr?=
 =?us-ascii?Q?9RpG1OWJRDuuGX5AkCDyfXDg5q9RQUWt0PH5Q5HEnTZTMD37C36XpVBkEu0R?=
 =?us-ascii?Q?rVlNMojFG18tFBYx7wBwX4fble/KDynzOZGJ/JZsFsp5WhkQCFKbvX3E+Lw4?=
 =?us-ascii?Q?N8AK2j6QM+SiYEURAKSpH1lmxVNO0Qm2263z0b5/sl/a903VnAMsnXRpavkl?=
 =?us-ascii?Q?wBIrph7wyBRMTCqBmlokLoZy+H4Q2Z26QeMJfxTW?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153212ae-f03e-4569-23da-08ddd8d003c0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:10:08.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzRZf5KhOepQ75wk4hpiYTsX7Oxfx9ECs9B3Ui+FQEJD29rrQfCKCvuhu3dttDo5S/YPoqTb0tJRXyOPTZajyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF93F545ADF

Removed unnecessary semicolons and used vmalloc_array() for array space
allocation.

Liao Yuanhong (2):
  bcachefs: Using vmalloc_array() for array space allocation
  bcachefs: Remove redundant semicolons

 fs/bcachefs/btree_key_cache.c    | 2 +-
 fs/bcachefs/btree_trans_commit.c | 4 ++--
 fs/bcachefs/rebalance.c          | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.34.1

