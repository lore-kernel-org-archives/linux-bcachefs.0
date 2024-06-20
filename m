Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F59101F7
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718846585; cv=none; b=jHe/VcLB33x0jWiKcbHEHi4D372JqniQWea0MtjOJoC9LfpIgzwLk+voVE/0rMshSLNsJ3B4KthD0gCC39XAB2gxLqn3eHcI2yx5R7XPFnGJAtGd7HptTr1NALmhzsabO5/N5sJbwyFNORcDvdU79Cg3QDXiIZOn4pZP9BeZ/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718846585; c=relaxed/simple;
	bh=saeGdpjWPdh327RdznjsypQ9fc88/+/qBMuua8BScqA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZocesoUkWr2n6LmTGcRW4l+l3u+HaR6eoHsa0t3rKeA7geOvL5g3WziVICMt/rEIEQm4GwdyNhd5g4pJNpXU3VB+qSPduNpKiajCTuiNrMFLOPShHBNB7tM5Y8mQ76Sn3c4KFUW771NedogmERdgWAR4ltFM6Vxcc6zPI0Zara0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GH6DHv7/; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GH6DHv7/"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718846580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e7M9DV95CF8GzH3oXpOgs7oAsy0oi0fdcYUzT4NpIjw=;
	b=GH6DHv7/UPMltkAsmlPv8Nfr3lbkRyrjX0pGG3vyYeMG07YohgupZY1MF4klAaBzaen+/2
	8Ti9cGa5y0rpyM8nAUOBaT/fw7XLwiKZGDsKwYLBCW8EHuTvC4czWA1a4ZjUN77z9m+yTL
	9zIwac2pamLWOi8TuuTjLrFsoqBbTC4=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: youling.tang@linux.dev
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: fix alignment of VMA for memory mapped files on THP
Date: Thu, 20 Jun 2024 09:22:42 +0800
Message-Id: <20240620012242.106698-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

With CONFIG_READ_ONLY_THP_FOR_FS, the Linux kernel supports using THPs
for read-only mmapped files, such as shared libraries. However, the
kernel makes no attempt to actually align those mappings on 2MB
boundaries, which makes it impossible to use those THPs most of the
time. This issue applies to general file mapping THP as well as
existing setups using CONFIG_READ_ONLY_THP_FOR_FS. This is easily
fixed by using thp_get_unmapped_area for the unmapped_area function
in bcachefs, which is what ext2, ext4, fuse, xfs and btrfs all use.

Similar to commit b0c582233a85 ("btrfs: fix alignment of VMA for
memory mapped files on THP").

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 96040a95cf46..b99a961b9f8f 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1155,6 +1155,7 @@ static const struct file_operations bch_file_operations = {
 	.read_iter	= bch2_read_iter,
 	.write_iter	= bch2_write_iter,
 	.mmap		= bch2_mmap,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.fsync		= bch2_fsync,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
-- 
2.34.1

