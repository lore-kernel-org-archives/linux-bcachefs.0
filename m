Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285881537D5;
	Wed, 21 Aug 2024 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724209087; cv=none; b=S04AHIFSR81xTioebmy/RaPqwlCvhYaG67dVnaVkXMSHpH7Sgya7fvSLH8gfkjBbNuTA/04Rl5jB2+Ejbp+Ozcr2AxBD3JsQwCJz8XU3qQLSqc1XCqbztXlGPgyVh2F8yCKuEtblPS+zM3s1144Eqj4xcRV7BQxdVySj6l8Ux7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724209087; c=relaxed/simple;
	bh=mMDkiKQacBGse7BesNAt1c0zofBdND9g1d8l+9ttsRw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYMEKSZCWjwAFA7Y8OvTz0gUWLgZpPg/7JyIx3zr2bNsQHy7KWadwgjxbNxK813FEWcUNPtkGQuJqM/PrE79xpRGDlTcpqdM2iWy60ihHqdmE9DCOm/NcYQmprH0mb+T502eJBigj5papnHTzrLZVF+qeTSjnc0RNXMMCDgTAF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L1U3ph018829;
	Wed, 21 Aug 2024 02:57:51 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412j0xkn7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 21 Aug 2024 02:57:51 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 19:57:40 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 19:57:38 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <lizhi.xu@windriver.com>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH V3] bcachefs: Add journal v2 entry nr value check
Date: Wed, 21 Aug 2024 10:57:37 +0800
Message-ID: <20240821025737.1785348-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240821023355.1619187-1-lizhi.xu@windriver.com>
References: <20240821023355.1619187-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=PszBbBM3 c=1 sm=1 tr=0 ts=66c557af cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=HrcfARfhlRt0sqxzS2cA:9 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: qnDQnxVXmhvuIJVQNBaD8rt4mgS17_di
X-Proofpoint-GUID: qnDQnxVXmhvuIJVQNBaD8rt4mgS17_di
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_03,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=969 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2407110000 definitions=main-2408210021

When the nr value of a signle entry or their sum overflows, it will
cause the value of ja->nr to be incorrect, this will result in the
allocated memory to ja->buckets being too small, leading to out of
bounds access in bch2_dev_journal_init.

Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/journal_sb.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
index db80e506e3ab..230ed99130e4 100644
--- a/fs/bcachefs/journal_sb.c
+++ b/fs/bcachefs/journal_sb.c
@@ -107,6 +107,7 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
 	unsigned nr;
 	unsigned i;
 	struct u64_range *b;
+	u64 total_nr = 0, entry_nr;
 
 	nr = bch2_sb_field_journal_v2_nr_entries(journal);
 	if (!nr)
@@ -117,8 +118,21 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
 		return -BCH_ERR_ENOMEM_sb_journal_v2_validate;
 
 	for (i = 0; i < nr; i++) {
+		entry_nr = le64_to_cpu(journal->d[i].nr);
+		if (entry_nr > UINT_MAX) {
+			prt_printf(err, "Journal v2 entry d[%u] nr %llu overflow\n",
+				i, entry_nr);
+			goto err;
+		}
+		total_nr += entry_nr;
 		b[i].start = le64_to_cpu(journal->d[i].start);
-		b[i].end = b[i].start + le64_to_cpu(journal->d[i].nr);
+		b[i].end = b[i].start + entry_nr;
+	}
+
+	if (total_nr > UINT_MAX) {
+		prt_printf(err, "Sum of journal v2 entries nr %llu overflow\n",
+				total_nr);
+		goto err;
 	}
 
 	sort(b, nr, sizeof(*b), u64_range_cmp, NULL);
-- 
2.43.0

