Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3CE573
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Dec 2024 04:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735446129; cv=none; b=Fo1qNMMnvU5MRPtzNT72J62+lxgM6ZgeOPyVsnaJbopP+oPYFlWbGwRjMWtVVzVwMpOJNB9HJfUejPRzxae6hy2nfgKQzoGpKiInxhC1IZjt6X0idOaYXfYVcsqCT8V7hrHh78+Wkqw9Es5C7Jk/5Gg+7/aykVWo2oLJi5VvFHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735446129; c=relaxed/simple;
	bh=rnaQcgxp8acWqoIPlm71xOOuFXy6OSmI1BE6s6F4VVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FTxfghV70J6xMxCOS15qDBzpSoVEw/vtyT708ntbO8rppjZst7iFL2f6n60Xnn0Ex5a7jnJBsxNtZyKBIH0yHS2Ifj9fSePUJo0ZYAn9jlU8QiTpdBVjWkhXkiFTw5xl+zzceqGZAOhPmDqmKNfjh9k+kdbqIsryVZbsxlPKCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=Ykkp23TF; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="Ykkp23TF"
DKIM-Signature: a=rsa-sha256; bh=HCkrl4q0Kewe+ZXMj5YENh8S3PMoaXmMoKbnUR2poys=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1735445185; v=1; x=1735877185;
 b=Ykkp23TFOimqBRSzpISl+lXH2DGfDmcsyLJJEQXZgQZu/+Tg0TaShvifIMThp4FQDhbPF0j+
 drADV/zP7gSm/YLY9gFtRnRjmQB7PNNSuYQsWJPqUuUnCW1fwK+wqy6rL50rY+FRSAVi+BNz69O
 ra0IbbkD+8uVR9APu7veeT8S26WDYrwrz3Qr7mY3uZCitocLqhMIB8k5JWMTn0EaN+VGRMFHEr3
 tqbmbdL5t/pC2Z2Kl4dnAZUGLloBhGqQQC9tqxlI16oPc/U2Tr49ZyRdlQj1IE1BPrUSW4Wnyt4
 tz/O12IQwhUhj0mX3t+nMMkAEIAmgAHtIw4adZXF32PCQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 3547dd18; Sun, 29 Dec 2024
 12:06:25 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] Fix build failure on liburcu v0.15.0
Date: Sun, 29 Dec 2024 12:06:07 +0800
Message-ID: <20241229040607.159965-1-integral@archlinuxcn.org>
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

