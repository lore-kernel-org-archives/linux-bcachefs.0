Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427AC2F2A;
	Thu, 27 Mar 2025 12:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079971; cv=none; b=lpOq5nrJRAUWt93PWV4ee3cMfLjhjrC6jgwP6K4HmLzvxNpzjMDwFQ4lBii5RsYreVWO/1sbcgVBeIRzEF4UdsKqg3a86HFNdxAS+ENEQO2E+kT73jVBKqYnPhtqCFLS386ZCLyYSlVCpi3fiqS36ESPHyJq9qU2hbyQsDufNN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079971; c=relaxed/simple;
	bh=kDcacIj/Y+T90hr0jJr5CvdFZhxFRaS5gTmVva6Yw54=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=DLa6xc8+FzqriebwTAv9lL9WmEzobfbFmSpXJIBIpf530IDpgjCMYx2H1V3wvu5WenmTvRv+Q+YVlj8MlC+f0xCru8pyxydhTI8B61LwzfjzaV/0GdhMG9sMv/IRJKZW/7rIkH+m8/SpoJICGYKjSXciS7s9Ztv7o0usII4BHb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=FvRe3Dfq; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="FvRe3Dfq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743079961; x=1743339161;
	bh=ir5gSoPP21iQdu81b4VD9fyuxfe2vR2H6ZZZR/cmXcc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=FvRe3Dfq4xmW6lgFo7RLUV9gKwCYWgQag3BBfpW9p4+244PnUSXs+mMDDxehZP8vP
	 nSOtorpFl6Pwa5SwtpPOh1JuC8ideAgnJ3xoQHQd0AEWFjjRHXycMDfn3FJ3G3CqC0
	 stCYYNW7BorSZSyS/5i7ETp0ckKw1ChVIqNnGmN2EdsRdKeBui6hQD4pBzYRUBQMUA
	 Vfx/VktD6mLqmdOQAfP7a+owS4FYKCfrm0+wNj+Mt0qq3/2zo/vmUpNx8zA2uMLN9o
	 12FnxZ0/7ix2PjRzkWRaZy39NafCoeX9sMIXX6dIkY9UKgZtm36+hYhAUf2BCZrK5o
	 QB5JmWCJxA0jw==
Date: Thu, 27 Mar 2025 12:52:37 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: mmpgouride@gmail.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: [[PATCH v2] 0/2] Use memcpy_and_pad for jset_entry_log->d init
Message-ID: <20250327125235.1958273-1-nicolescu.roxana@protonmail.com>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: a3b376fb33c6156e4595533450a3afd9df72aa11
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


