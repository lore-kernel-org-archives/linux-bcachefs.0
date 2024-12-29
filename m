Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D86AC139
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Dec 2024 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735445277; cv=none; b=a4Gsn1eF0y1D0FXPYvGgX6eLtb/kLNn5q3w1aJn2RoV4uP9c8ERF+df5mLn6FbiLsnGwr4CDM9pTj89zpn7+/sbXYYeTWTo4568xqmIo2YzldbhvSfCp0mrzgVBEWHWIEXHDNz8Y3dwnJnJDjdL0ENFR5tybFkdf+nNh33RExkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735445277; c=relaxed/simple;
	bh=rnaQcgxp8acWqoIPlm71xOOuFXy6OSmI1BE6s6F4VVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=br62z4KV8fe/QBDCLMBEL46HJnpxUQJJ6lmvv4wiUQXdlZYj54BetEi7S/2CAEfsQkiUF7CbFmz27+vFAnr3woBaS4gm5M/VG4EgqyCkAhKRNVLf03ZERuTuSQvYJ88gtsu0OJNirLuCQ7PM+6sOCpbagnGcmiXmKQu17lxxVwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=675GXKOC; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="675GXKOC"
DKIM-Signature: a=rsa-sha256; bh=HCkrl4q0Kewe+ZXMj5YENh8S3PMoaXmMoKbnUR2poys=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1735445271; v=1; x=1735877271;
 b=675GXKOCrfiGcEI+sSLfkGLVmJr9mvZekvExTCay3bNsVrgIuaNnOJ3y+02X0IT9ed3GLx1z
 XJEzj3+CIkHC/bjOFgr1UUhyDH+jAeT/vTJrEzlchHABv99x4U6pRDbOdpUl6va1Z9n6Eiwh+LP
 WTdHzI6QAviNKT7v9Y9dLFB0lWmCtMLSlOf2RIe2JTxgddJL2Ge3ET4/beQHKzwa4qfG6bAMHi9
 Z9NhXun7G35/pnhmItXwPSxFfXl/R7+inFYg1dD7VZp6uBrb/r+gZbiPcrumImbMfGVQUTT8Y+1
 m0q1VkdGe4pVjByz7eqeD+NZ1aHB9E48sJ3YORR65ZlxQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 08bd86c2; Sun, 29 Dec 2024
 12:07:51 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH resend] bcachefs-tools: fix build failure on liburcu v0.15.0
Date: Sun, 29 Dec 2024 12:07:40 +0800
Message-ID: <20241229040739.160204-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After upgrading liburcu to v0.15.0, bcachefs-tools failed to build. This patch
fixes build errors on liburcu v0.15.0.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 include/linux/atomic.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index f7b2619a..128f21f6 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -188,12 +188,12 @@ static inline i_type a_type##_read_acquire(const a_type##_t *v)		\
 									\
 static inline void a_type##_set(a_type##_t *v, i_type i)		\
 {									\
-	return __ATOMIC_SET(&v->counter, i);				\
+	__ATOMIC_SET(&v->counter, i);					\
 }									\
 									\
 static inline void a_type##_set_release(a_type##_t *v, i_type i)	\
 {									\
-	return __ATOMIC_SET_RELEASE(&v->counter, i);			\
+	__ATOMIC_SET_RELEASE(&v->counter, i);				\
 }									\
 									\
 static inline i_type a_type##_add_return(i_type i, a_type##_t *v)	\
--
2.47.1

