Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8422BF012
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=g+pOuLXilhU3BekQYXOO39zStP3LQ2W88zxD6aW6dloOju+uOWhLWdalXiQvSPN2KbrFgAESUSkxodtwLkN1+CCZh15LIe63D8ZoMVwBkXimGiVnlI0W9aJnmS5MUMKKWlbilXCrOR1I3EreJo93OCKVxCV0fwyB9CBJYBJORxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=lLHdQ1hMH+GgdBw45XWLn/2VdbVNvGmdJq0+ty+n8vI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Adt7u5/x3uIENi44xl7UNcel/Rct1hVkX8IKaeqWe9YfGMOdUuDQk3gZ2eTHM3x25+3eEDKi0C8z8ElptYjXmdsfrycB9NjpXEdcYEZphqutgYfCYwfxb4dYY77imzBnLOGkfYQREuzKkb6efQ0UgZLH+bV1dRfK59fXcGOaK/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij17p6XZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij17p6XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F5E1C19422;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=lLHdQ1hMH+GgdBw45XWLn/2VdbVNvGmdJq0+ty+n8vI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ij17p6XZcMba00m42Q14BFUJMHiuEF5nemehxjh/szXgACaN+fvtODcYv7iw+f/bw
	 +cKVXoKG2An558DvM5W9TnXE2FYYMt3RM61Ddu+C36z/VNZ1sw/wsWx2iT/jmAmvJy
	 y4hIODukt3LslbPb1ZHQfswn47SoVmEytKOuY+TKoNLpjsjaDAIzp/l6X3aeAgohay
	 3Kh+AxWqX0yG2ibLWQjhMWEpVssx/mGJgmdbiDjheZQ0FMzukcjTp1lpf05tSQ0ffz
	 0Xr4ByGZ0Rjt17PkRDNaDJy1OfpAYa6sMKMYQFQ9rHJsWAWCKLPzKEf/11gH8X/HbM
	 TNFnAlyecVnsA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FEDCA0FF7;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:14 +0300
Subject: [PATCH 08/12] bcachefs: Fix progress reporting for unknown btrees
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-8-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=698; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=xGkyrAFw+BdX/Ys6wNZqMpzMb7Z1sVfbEKCODOS+HVs=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5KZxPJC5/+Jthmykf9Ol2T2Rm1Zcsz3meNZ15yg2
 fnh/PF/O0pZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBEtAQZ/umqJ83y+NfK82xO
 0bPw3z+2Xdi6WSIoJUhlk/TR6TbRZ3YzMvy7OqG+LIv/9BErlfd+0gpv0r417i28u+bkdoc8F8Y
 3e9kB
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 013eca7d6017a81390001519f20bfc4d0c6bc173..7cc16490ffa98fec34ff228cb56bd1af0f42da3d 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -19,7 +19,7 @@ void bch2_progress_init_inner(struct progress_indicator_state *s,
 
 	const u64 btree_id_mask = leaf_btree_id_mask | inner_btree_id_mask;
 
-	for (unsigned i = 0; i < BTREE_ID_NR; i++) {
+	for (unsigned i = 0; i < btree_id_nr_alive(c); i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
 

-- 
2.50.1


