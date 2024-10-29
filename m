Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89B62076A7
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Oct 2024 20:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730232038; cv=none; b=MGfp8fQhK/K9OCL87ab006/D1sjLry3acDJJISZK/3x7AxclhP0yOWOjDD5yEDqVUk3kSb+1zWIHkISqkEMnCQ3IHpRUfxHQg2ZPgRzdLBow4PslKWwxuxr/WDABKrtlscE/7a/EZ2MiBhRzRZpeILulAsc3e5l9l5CnEKTRlD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730232038; c=relaxed/simple;
	bh=WSuLei12jKKXlOidayNwY86rZHMLKi4QKMe5LX2QDGI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=b9yJIvON6f8LqhpKvlqOAkiQ+6l9ZbjZdC8Fkst+bdB9J1Dq4csk1SCZ/LNBGvOJEWe1slZ4G5cSNtfMJu8/4Zf3qyqzAZ18sbcVkoXgCWyayfB7SqZnGp3LVOF08xmMHz4dw6AnO+MpzxI0vmkAdH9So71BSfm2w7Gz6/7bVK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OX0R0Ak1; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OX0R0Ak1"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539e681ba70so263e87.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 29 Oct 2024 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730232035; x=1730836835; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WSuLei12jKKXlOidayNwY86rZHMLKi4QKMe5LX2QDGI=;
        b=OX0R0Ak1W9zhpZGA8ox9dx+sQR5aczZO2eQqbi0SZXyFMJYhZ8NR7B9yG5Vyfm7q6u
         uUWC0QRRfCpmWjEyT+v+uhlm0nXiv5Lx8H5jLBzsD26QY42S4NjSvJSoy3JzURdaA7Yf
         Ybcp+fITmTCvDAelIOJI6IrZDxFfIDOS7rnfwvibT84oLaz12dFriocAjpJUFrNwXWly
         V3/rqoruoWViDXS5xFnOiiYZ9HjFLgaaRdZGWwjqKYjvEq5coiLwEni9UmWrX1bCzpin
         9pcNXz8f/GLCl4u5ttUVPx2wwWXGMtfDCRO8DYGRu6ghtm0Ry1mjaEANiFnmw3R5w/46
         7a3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730232035; x=1730836835;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSuLei12jKKXlOidayNwY86rZHMLKi4QKMe5LX2QDGI=;
        b=D1cVagEJ3Ku+E0HaywSkb9f0adTcuicx4zYugZTITWCtqy3jHoVFcuEoyT198V8nIG
         CBnNzRZu0j10p0yEg+2obV3uMjzgWUPxPl7QSQa9tX6fEmCiXJvzh+50p1p7kiTlDsW+
         cZ1MMGeub3YlZfstRP4MGoEdaLU85+kRy9DW1ln6D61j48VxgTA6NTbhaEbWda+XhJk2
         U1pAwHAEbpqPsxJN3Y4OxVZKzNQb5OO5bFMh2OHQS8ktS88fB4li0plrlRvn2sY+lnP3
         Sz7+OauqxrCcFvU9ftTDTxhCTvAsY0/PHwzz9lc2hEIA50T+Hu3ShqPeeLuHMqJ5xy33
         Na6w==
X-Forwarded-Encrypted: i=1; AJvYcCVs4l8mxzv5CscHuznudZ3dXqVN3BuHuW6C54HST9A+oTv4lFlwaKVHZxvqBGqCmORe3hDgTPZ313rpuOdJUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBGAT2jZVujGR7/c2jgJhQ16EWKiYY8dlsKjL2sff+i/cDHmkc
	Tcvr65Qkkk8eMF3VxK200YtLGf63kJRI7+MMRPiUyYN+Y4kbmnswqAf1y4WlpYeVlRzGzVrUGOp
	k/mBhfRS5UtEwxHryxTUTWtX42P2R2iqUabw+pjr+oxsbizPEELo4Dy0=
X-Gm-Gg: ASbGncuzfBSEaxTJ02+oDBBJ5wpSAMTohTg9lBt0UIHWfmUzt3ldIQklyHy6RTeJG/d
	QU2nJ9xScAOl50cWE1MITQWigE/2TxrAVpirOBSVFQnNWwhJ6cl67FpI7D2MD
X-Google-Smtp-Source: AGHT+IGi6p94s9TGLbzQ6vmgo0pdV/crWP5wzNn9v80ucaj36tbk76xyFFsz0EBrmekAX8qGFmyhaeqTrj3b4aKYuzI=
X-Received: by 2002:a05:6512:1291:b0:52c:dd94:73f3 with SMTP id
 2adb3069b0e04-53b48bfed8emr549736e87.3.1730232034546; Tue, 29 Oct 2024
 13:00:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Tue, 29 Oct 2024 20:59:56 +0100
Message-ID: <CAG48ez2QercBeWuj9+J-s+2T0ShK-eVfsDm67bHY8NezdAL30g@mail.gmail.com>
Subject: bcachefs security with untrusted block device
To: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

I saw at https://bcachefs.org/Encryption/ that bcachefs is supposed to
be secure "even when the attacker controls the storage device itself,
and can see reads and writes as they happen and return arbitrary data
from read requests".

That same page also talks about using key version numbers to ensure
that nonces are unique (which, as the page says, is important: "Note
that ChaCha20 is a stream cypher. This means that it=E2=80=99s critical tha=
t
we use a cryptographic MAC (which would be highly desirable anyways),
and also avoiding nonce reuse is critical.").

What happens in the following scenario?

 - the evil disk takes a snapshot S1 of its state while the system is shut =
down
 - the system boots, writes some data to disk, and shuts down again
 - the evil disk takes a snapshot S2 of its state
 - the evil disk restores snapshot S1
 - the system boots again, and writes some more data to disk
 - the evil disk takes a snapshot S3 of its state

When the system is booted off an old snapshot the second time, can
bcachefs end up reusing nonces, such that S2 and S3 contain different
data with the same nonce?
