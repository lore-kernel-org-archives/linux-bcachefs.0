Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955DC16A39E;
	Tue, 20 Aug 2024 07:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724137920; cv=none; b=KKX/SUMAZSWBztaEcR18x3uyPxzB7xe9e7MlDDFRy24z4bAk8ZOA4fhzWMsnje4mbTVOW/PcdaejXhvxV1Z8HYSnDAFk6sSiD5qeBb7b9cZIYAeRaw6jXyz00ou+vW42k2mTLlxE8BK834tW6wjheUc+xt9pitALejwkHCPz/Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724137920; c=relaxed/simple;
	bh=nRMWipEt64KQKIGPBo1545mdc9+ppEaeptFgBeVL/6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfMTZJRIw92u7h1iRN9hy8uVviNB3N/p+QDHfSQN95MZJb6AvAARVmdCgHZQfFH7C/8eLHO+LdgzFCX7STj8kCHKiYg0fKbD6vukiA8sDrrj4WAIeF83aIuLXQHiLBnKm2E35fOub8yGNwCdxybUXZSikN1qBjKnEsb2vJcnIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47K51YED003789;
	Tue, 20 Aug 2024 00:11:49 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412uck2c45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 Aug 2024 00:11:49 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 00:11:48 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 00:11:46 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizhi.xu@windriver.com>,
        <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH V2] bcachefs: Add journal v2 entry nr value check
Date: Tue, 20 Aug 2024 15:11:45 +0800
Message-ID: <20240820071145.1109560-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <m5tgdpvt4bzaikdmhlxzwrceww5vh5b237qesdosf6nn4hyhan@4brk2v5w26u4>
References: <m5tgdpvt4bzaikdmhlxzwrceww5vh5b237qesdosf6nn4hyhan@4brk2v5w26u4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SIcQV/vH c=1 sm=1 tr=0 ts=66c441b5 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=yQR0iu-ZAwy6vDbhzTIA:9 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 8uYMeEbOpqZd_DzlHHz7faIbaLclNZWT
X-Proofpoint-GUID: 8uYMeEbOpqZd_DzlHHz7faIbaLclNZWT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_16,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408200051

When journal v2 entry nr overflow, it will cause the value of ja->nr to
be incorrect, this will result in the allocated memory to ja->buckets
being too small, leading to out of bounds access in bch2_dev_journal_init.

Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/journal_sb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
index db80e506e3ab..db2b2100e4e5 100644
--- a/fs/bcachefs/journal_sb.c
+++ b/fs/bcachefs/journal_sb.c
@@ -119,6 +119,11 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
 	for (i = 0; i < nr; i++) {
 		b[i].start = le64_to_cpu(journal->d[i].start);
 		b[i].end = b[i].start + le64_to_cpu(journal->d[i].nr);
+		if (le64_to_cpu(journal->d[i].nr) > UINT_MAX) {
+			prt_printf(err, "journal v2 entry d[%u].nr %llu overflow\n",
+				i, le64_to_cpu(journal->d[i].nr));
+			goto err;
+		}
 	}
 
 	sort(b, nr, sizeof(*b), u64_range_cmp, NULL);
-- 
2.43.0

