Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE8217F40;
	Thu, 27 Mar 2025 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743087014; cv=none; b=LLW3+Y20esimURiJfhL3MerVRrHensQ/gRR/EgaXZpJ7ixYszoDwfvc/sBUfRb4HcVNv90M4au+dAYc3iGPxKItdh+2h36eFSBFPuR7o+2KQXyI61qDAwwyg83yPEI9sZEmGMaTxh0k+OXBrqXoJXtXq3/EQbevLZMtaPRodHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743087014; c=relaxed/simple;
	bh=kDcacIj/Y+T90hr0jJr5CvdFZhxFRaS5gTmVva6Yw54=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=e1CZ7YD2QbCbRowHmjqK7Rp+yGN3w4BVuZOzKwoTanmBvl/SdNcIfMdP4BzrpU+MnPCK1BHO3HzP8Pfac74ePp2RP2gvqoMVZg9dPyCeLd02TFPYyhQD3a8twwJWAX28LGjWkbKLJWIrq/IDJhMBIeqK9N+Zk4OhVHxQQqJ9Mz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=B9GlcUMm; arc=none smtp.client-ip=79.135.106.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="B9GlcUMm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743087006; x=1743346206;
	bh=ir5gSoPP21iQdu81b4VD9fyuxfe2vR2H6ZZZR/cmXcc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=B9GlcUMmyaHyOZCppTQKIqpTeeFpgokBl0mGZPfx7Ic42Uh+15/bH5HwYC9Ht5bI7
	 Mp6n6dZ+7zvShFAUM3idUC/kEoAXc8S8DOuhf6c3vLaIAeuRLRWVH8H8DoZKoeVxwZ
	 PBu/l8uAfrWH/oEuB0VRLyR914D+3n41/6V05RrznEM3oOv4tqLkhsKYuFJFcHG59r
	 BJQBP4cHVVXEdkqLVSeBeIBVQk4u2pJQn9AfGSE2F70hkmnRDJQp9KCTF4nP1qxBqI
	 /wzz9aZjiPuxFcGpNoKFl/F2c1cuAyn5drjnlAqARXANcWIla5dGlS8xfFphZzWmX0
	 ejHQZ730Eub4w==
Date: Thu, 27 Mar 2025 14:49:58 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: mmpgouride@gmail.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: [PATCH v2 0/2] Use memcpy_and_pad for jset_entry_log->d init
Message-ID: <20250327144956.1974622-1-nicolescu.roxana@protonmail.com>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: 81761c1e7248b942c23446258540ac3bbff18f6a
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This replaces the depracated usage of strncpy with memcpy_and_pad when
used for initializing the d buffer of the struct jset_entry_log.

The other 2 usage of memcpy were also replaced by memcpy_and_pad.

Changes since v1:
- since the dest buffer is not required to be NULL-terminated,
  memcpy_and_pad is used instead of strscpy. This adds zeros at the end
  of the buffer if there's extra room.
- the same mechanism was done before in both __bch2_fs_log_msg() and
bch2_trans_log_msg by zero-ing out the src buffer. The second patch
replaces that logic with memcpy_and_pad to provide uniformity.

Roxana Nicolescu (2):
  bcachefs: replace strncpy() with memcpy_and_pad in
    journal_transaction_name
  bcachefs: replace memcpy with memcpy_and_pad for jset_entry_log->d
    buff

 fs/bcachefs/btree_trans_commit.c | 3 ++-
 fs/bcachefs/btree_update.c       | 8 +++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

--=20
2.34.1


