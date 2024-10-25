Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79D18B484;
	Fri, 25 Oct 2024 10:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729850546; cv=none; b=MVqyBWNTBjfWaspQ8/NSmRP053M8vAFq9oeRj74XB6mEx+MgUv5Yu8Ecfed78/Qq6QFQaZyrTjudU2mu4XZd1b2Y2J7+chR/I6bnMTw/5CgSi7xlY29Xv/9UNeogon0dqYIjYBLHcqLHQ75E6V7SrVODJJVTH2WA7ic6K4l44iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729850546; c=relaxed/simple;
	bh=okB5QlGXVYpQeofMhkNxYXKeEG/e5taAkmt0VxTlBys=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxv0igWMe6+iOnQGaBwK70dJx//WDl8NAMQj1WzM3CSF+3tSJEny1qjTUj8C11kaF6b8QDpGZMAOI5jxiSU7WgkNiA64+iTEFQCm8ElH5dCgBDlB6bANgsSDW9Fqqxf0c9zfrbzGPOg36WK8wh3R11NCaCJkJqEnohRzSKXTXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49P7cv23004759;
	Fri, 25 Oct 2024 10:02:09 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 42c3r77yd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 25 Oct 2024 10:02:09 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 03:02:07 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 03:02:06 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>
CC: <bfoster@redhat.com>, <kent.overstreet@linux.dev>,
        <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_reconstruct_alloc
Date: Fri, 25 Oct 2024 18:02:05 +0800
Message-ID: <20241025100205.635960-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <671907d4.050a0220.1e4b4d.008f.GAE@google.com>
References: <671907d4.050a0220.1e4b4d.008f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=b8Tg4cGx c=1 sm=1 tr=0 ts=671b6ca1 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=DAUX931o1VcA:10 a=LP8bkyatZF1qckLwfJgA:9
X-Proofpoint-GUID: p-OtpK2LlmnL-CR0u5LNxt6n7gPJrT70
X-Proofpoint-ORIG-GUID: p-OtpK2LlmnL-CR0u5LNxt6n7gPJrT70
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_07,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 suspectscore=0 bulkscore=0 clxscore=1011 phishscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=570 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2409260000 definitions=main-2410250076

The counters will cause sb to be realloc and release the old sb, which leads to uaf in ext

#syz test: upstream master

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 55e1504a8130..9df0969c29ce 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -59,6 +59,7 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 
 	mutex_lock(&c->sb_lock);
 	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+	void *sb;
 
 	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_allocations, ext->recovery_passes_required);
 	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_alloc_info, ext->recovery_passes_required);
@@ -94,7 +95,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
 	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
 
+	sb = c->disk_sb.sb;
 	bch2_write_super(c);
+	if (sb != c->disk_sb.sb)
+		ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 	mutex_unlock(&c->sb_lock);
 
 	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
