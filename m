Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99533145336;
	Mon, 19 Aug 2024 06:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724050093; cv=none; b=g6aTvVoBneP6f2stw3PtKXEzzt3axAggljOgHFCAYjm5SC3Ua25LaRhbDwmFfjgtkh7dPOH2nmd/2ReOF9iEfgvVzBFjDFvt1AcSsw9nAuo/qyI56rLqBDx7rVogaeIBNNPzKyTWqG55k378o40ZvKibfh/Jxd6w38DVYxk82sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724050093; c=relaxed/simple;
	bh=XQcRKptzhGzWoDZkgoWTXwwakv5CcQmXtYtLcYuCm84=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9gniO1JFNnVw7aORcazo5l9P94TMhkBd9jqTr/asqPm8jKAyRrE4un3L4Be5wNcHbSGjKnDHgaHylc/Sz75OdXCiS+T3GI7YOZMTKAeg3jFw5oYdkjSm5XGW54BzO+a/7wbbx0sKg21zRx5yEWUZox9oJFCX7aHuMQXCMkqurE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47J6hCsJ016905;
	Sun, 18 Aug 2024 23:47:57 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412q541a5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 18 Aug 2024 23:47:57 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 18 Aug 2024 23:47:56 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Sun, 18 Aug 2024 23:47:55 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] bcachefs: Fix oob in bch2_dev_journal_init
Date: Mon, 19 Aug 2024 14:47:54 +0800
Message-ID: <20240819064754.35606-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <00000000000071b7c5061ff83639@google.com>
References: <00000000000071b7c5061ff83639@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: GPV5K47ay8fBZy-a21CvzZ3TvHcgsDaH
X-Proofpoint-ORIG-GUID: GPV5K47ay8fBZy-a21CvzZ3TvHcgsDaH
X-Authority-Analysis: v=2.4 cv=b+3g4cGx c=1 sm=1 tr=0 ts=66c2ea9d cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=edf1wS77AAAA:8 a=t7CeM3EgAAAA:8 a=HHOYXQOj0ksufGrR42kA:9 a=cQPPKAXgyycSBL8etih5:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_04,2024-08-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 mlxlogscore=819 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408190049

When journal v2 entry nr overflow, it will cause the value of ja->nr to
be incorrect, this will result in the allocated memory to ja->buckets
being too small, leading to out of bounds access.

Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47ecc948aadfb2ab3efc
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/journal.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 13669dd0e375..d4fb5a23b3f6 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1307,8 +1307,18 @@ int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
 	if (journal_buckets_v2) {
 		unsigned nr = bch2_sb_field_journal_v2_nr_entries(journal_buckets_v2);
 
-		for (unsigned i = 0; i < nr; i++)
+		for (unsigned i = 0; i < nr; i++) {
 			ja->nr += le64_to_cpu(journal_buckets_v2->d[i].nr);
+			if (le64_to_cpu(journal_buckets_v2->d[i].nr) > UINT_MAX) {
+				struct bch_fs *c = ca->fs;
+				struct printbuf buf = PRINTBUF;
+				prt_printf(&buf, "journal v2 entry d[%u].nr %lu overflow!\n", i,
+					le64_to_cpu(journal_buckets_v2->d[i].nr));
+				bch_info(c, "%s", buf.buf);
+				printbuf_exit(&buf);
+				return -BCH_ERR_ENOMEM_dev_journal_init;
+			}
+		}
 	} else if (journal_buckets) {
 		ja->nr = bch2_nr_journal_buckets(journal_buckets);
 	}
-- 
2.43.0

