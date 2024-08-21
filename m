Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C79A79F4;
	Wed, 21 Aug 2024 02:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724207645; cv=none; b=EejM6RWYJjNyV4P5RuICSRAlBBR4do+3AjjEv1VsE9iFWN4WY2iw0xWSrLbdwuPL8Ann+uRULfRUF3J/5WwgZWQ7WhOtXdGIONAXjcLG+34yEbKEdnz4xYbnMZzbHm43/5VopH7WasyjWSASa4nlafQBPQGQwnJ0ix+z2S9UwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724207645; c=relaxed/simple;
	bh=OX9yCF8RGGtCUjG3EyIIWF87Au3IRhM/+D2JdgUTXgg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pal4UNkiKqlrkZ0aRNxCZxQahxzG9r25LxlZJO+2QwMn6d1j7KOUdX/GHFerxp9w8yiXajU9TUbKRrPOEkaVSNJtmD0DY7LYLkylE2pYZVkWluX4oPlbVL62WuXrZO8V56Y5B4DtKJBFzvD7bNxM9L1sFplacXUmU1olaCDQ5TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L0o3rQ029073;
	Tue, 20 Aug 2024 19:33:58 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412uck3au0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 Aug 2024 19:33:58 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 19:33:57 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 19:33:56 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizhi.xu@windriver.com>,
        <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH V2] bcachefs: Add journal v2 entry nr value check
Date: Wed, 21 Aug 2024 10:33:55 +0800
Message-ID: <20240821023355.1619187-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <rtuy45ppvbi7yoighz2uvxwauotsyt5jr6kwfp4bsp2g43f342@k4hnm3xmqotz>
References: <rtuy45ppvbi7yoighz2uvxwauotsyt5jr6kwfp4bsp2g43f342@k4hnm3xmqotz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SIcQV/vH c=1 sm=1 tr=0 ts=66c55216 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=f1XBeclc1n_UNk118noA:9 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: hlPzlC02xgZ_cl0IZ58Q8YgXguFpNByO
X-Proofpoint-GUID: hlPzlC02xgZ_cl0IZ58Q8YgXguFpNByO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_02,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408210018

On Tue, 20 Aug 2024 19:34:18 -0400, Kent Overstreet wrote:
> > When journal v2 entry nr overflow, it will cause the value of ja->nr to
> > be incorrect, this will result in the allocated memory to ja->buckets
> > being too small, leading to out of bounds access in bch2_dev_journal_init.
> >
> > Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/bcachefs/journal_sb.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
> > index db80e506e3ab..db2b2100e4e5 100644
> > --- a/fs/bcachefs/journal_sb.c
> > +++ b/fs/bcachefs/journal_sb.c
> > @@ -119,6 +119,11 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> >  	for (i = 0; i < nr; i++) {
> >  		b[i].start = le64_to_cpu(journal->d[i].start);
> >  		b[i].end = b[i].start + le64_to_cpu(journal->d[i].nr);
> > +		if (le64_to_cpu(journal->d[i].nr) > UINT_MAX) {
> > +			prt_printf(err, "journal v2 entry d[%u].nr %llu overflow\n",
> > +				i, le64_to_cpu(journal->d[i].nr));
> > +			goto err;
> > +		}
> 
> no, you need to sum up _all_ the entries and verify the total doesn't
> overflow UINT_MAX
The overflow value of le64_to_cpu(journal->d[i].nr) is 18446744073709551615(for u64),
or in other words, it is -1 for s64.

Therefore, the existing check for single entry is retained, and an overflow
check for the total value of all entry is will added.

BR,
Lizhi
