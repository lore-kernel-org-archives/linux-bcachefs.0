Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93019F471;
	Sun,  1 Jun 2025 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748792257; cv=none; b=YEwLGOwtnXXC3sp7T9Lq7ipDl/eMUvMK+KG8k0IU0m8kHOg1H3UI6TsVPngCE5bflSW9r+bghIjWYPOrA/P0llgqW7ussdwW58hTd2kBExr0ohAKvSFKTyX4DEwGEKvqFBZ2hHQYjXH1HqceS8+ThRqf1wMfNr6NQFL8puJlNJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748792257; c=relaxed/simple;
	bh=G/BXMMd6DVVIda0YXTwBGbbnjOmqb0xXDu/5Kj+Dy+U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=g9kmhmPYL6e1QrTuP9/yd1tJ7M3+EL2VD8dYhKhgU1F1hNdGUoWOyIyxxglArAClibFHq5zhMlWPR59hShYSLwxkKOaLta1lPolONj91CrsAWfUGwe23vUk92ZlAk5nLFpPoftSUaN/jvR7jEd7eRPs8DsEEu9Pb5HWsjfvmDyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8dy7gF5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8dy7gF5"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22d95f0dda4so44330445ad.2;
        Sun, 01 Jun 2025 08:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748792255; x=1749397055; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G/BXMMd6DVVIda0YXTwBGbbnjOmqb0xXDu/5Kj+Dy+U=;
        b=i8dy7gF5FLyppXxTKQ6LUEsk23OYkveiGfVRqhVPtaxZMopN8uIb2gYwBYs2Ee5xLn
         YhquDUrsJ/yeZu2dGtVWFTGXj1CsScTRCXK8/yVFcTKY4NeNZtLqCd/x+skL0Kj07hWK
         yUe/9fyOg3tlpzZemDMmEK01FfxG6jmP9aYuLBXGEtzW09vkRhYHPAYuyajfu1praWAI
         AmYZCxOnbDdmTzU+PyDd5l1j5wCzuZW6d6F6+asdkclahzdL9zWkxkahw4HDmxXqajnr
         lcaAe2HdSf6vFw5OXs0rGObOePU+ktGfOv0zlnGkPOSTSVlZT/2kCR6nDJAuvxPhM03I
         wvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748792255; x=1749397055;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/BXMMd6DVVIda0YXTwBGbbnjOmqb0xXDu/5Kj+Dy+U=;
        b=rqRcTkB/ZCFRx+6weQ3u3sxWZzPDwRMZ/kpamCDbJKG+P+PXRdU8R+ms5UaT5kELll
         nMAnZh9Xi1CGrjxi0zSwG8GePbjo4sfG872+zfV0orxnRLU8sUhx+IghTn6rieAscTP8
         7Tuy51qgAS+s/m8umd81+DbfJ22Ow4N+Ba5YcPz/+MtVKQTv7eYH3kKoO4NgTzbkCPis
         c83eyWxI/o8tRvOwUWLLfNXTouVmd/hM7Kh2Xj9YyNxaXctu7FY6mkfw9CRBXgb+6OHt
         eszO77jVCG7vQ0vQ+0GFfWzumKVWddqUIKxS3qQDnYESExroRjv8LI6jcGGHK/jHZF7Q
         rQVg==
X-Forwarded-Encrypted: i=1; AJvYcCUHeIih30OtKGZPEQ4RYMdsJycp8h3JlFMquzmHrst9H/ceyS364BZR1jCt4gVbRkWEF8IWHS1vGBkpoi21lw==@vger.kernel.org, AJvYcCXUd7DlSrmOPtWoLFsvS9mjJA4oJQ5F/GnzrtSoa4Xu4TJH99jM/vSNREizdUdo6EXtpXv2OLcMz0Ss8MKX@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3f58WG79aI5JEy+TJpPC2tNdPhxkOkUrZi9Ev3ZK6BK2xyERM
	rY8iMS8wZpW7KYkKiRefw7jfd8N+WkNevXhOIN+mw3lKgVXs3R8ysGZV03NOuWUbT4rnXWOXv0r
	ySlD3KuRvZ5MhZp0alTwDQbPJ7g+EOx0=
X-Gm-Gg: ASbGnctea70sNkf+H6+DDd/Uc+ep9N/SkRw3igXtszw9ZObDb07dPtk+ztMQJJwPSHt
	jhxuYWEyQgoriiCdj5UuSGXJv20ZZHrzabWURvYgsei1Lr9w2Xr3MKuVil6WvHI9m1KMSyK9c4I
	HI/Jxgq2E47oD4h0M2HRYgxBloxc+u0qMS
X-Google-Smtp-Source: AGHT+IF+MLpSv/FVlvaFPFfczv+aaoBcQs41DWDRd7phoEr+10VVjSnDOk0G1Gr5hSUXI+YeXBnSqgY29lJ7sGyjXgI=
X-Received: by 2002:a17:902:ecd0:b0:235:5a9:976f with SMTP id
 d9443c01a7336-235291efe5fmr155943745ad.24.1748792255153; Sun, 01 Jun 2025
 08:37:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Sun, 1 Jun 2025 21:07:04 +0530
X-Gm-Features: AX0GCFsyfeVn3C6GpJClP-GmFD6sVXtW43zh9SWzPZu6RmWtMwEYxwg92Jp75lw
Message-ID: <CAPZ5DTGrXzDXXB_2DauvTz7zJ+jni262rkiZ_SYbtAxEES0cXg@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in __bch2_bkey_unpack_key
To: syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

The bad format is actually caught by
btree_err_on(bch2_bkey_format_invalid(c, &bn->format, write, &buf1),
...) in validate_bset,
but since the return from __btree_err matches BCH_err_fsck_fix, the
code doesn't really do anything about it.
