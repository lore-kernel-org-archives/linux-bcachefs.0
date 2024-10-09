Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F544C8F
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 03:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728445805; cv=none; b=W4j9C8x9nhv1xj3hqGkONPmYgUglsEJhL8AapQkW2+LOONzotWO+b0szwSpYmPSkV5mQaa8fpsD/PYegdYjVO9WJSViBHAa6nM9A/o77lQPZInRYXYTcQfgWSWUsKIs1M+6OmGacoNX1l6SO1SGeUG7N6DFBRgD1nj6prGyuw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728445805; c=relaxed/simple;
	bh=2pzntAbDepUFPLzEgBid8WcHpvGzHwCjJYl+mmrHnDo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mljektKCkNi1iUUAcuM/l44n1Tt3BXP957/0TFlSF90SuRF/pCpUL4JNIHIo5N7AMmSCI+LheYlL59CE3/9jd0XQuMedRkwC7xYFyCxHkeU5ep8N+Xv+sspF6m7mlqJGUmc5qNE7nVCZUC6pD7OcBCjcz8A4L7zvaA64d4Xlaps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a348ebb940so66709885ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Oct 2024 20:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728445803; x=1729050603;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rw7rJSCiCXfgr4IOyT+sg+vA80oPk9jU0sR6X02fBho=;
        b=F2oW/wXvHrCm5iNcPb03AyXunQ5+mOJbTttrOSi4uO/wu4L+Sgo32dZ4PAtzhxcwGK
         EIXLBVFL0jYAokE0Ldq3aGsn4sZe2eKTJym/lXXg1jO0Oh5KJ6TnKAYX3WSteqYmefBk
         oz0+qUOmH/RBo/2sD6TBr/jgLHFOqasOr+6bRsJRmmRVXSpmKc16SsAIUF9GjuNycJJU
         nCviGms/ALqu7fbdClwyIXorsfIw/kwp5iXnUGDsrLn79KiDvgeFFj9BAjOVLYTiY8Ru
         O5tVSdC141rRzHLdRYf9YayQMeGrd3dtc9r8MaoVUeAajVlELBF2LFyPa8NdoUabmx6p
         +lsA==
X-Forwarded-Encrypted: i=1; AJvYcCWufQED9ani5O8p3wnhRsDZ9o8Opm1JZw6cv+H62N2QcZYPNJlprm6JbJb8THZmKWtw8mJc5qnDY1XaYCDvMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh22CtAEPaSRgXpnzAziUlihma9AQF65z3M/n6gvGISlFfjGtd
	T2RI3hElXd13Att0vhBMZBTvtEtH1IGIDm2ecnK3cRh5lo3Xh0gv7H1GE42a7mnLxUsP2Jbhe7T
	eqV0mtRr53G0yuLGEYES2DUy3Y+VQ4AtEXeaHH2qVWR/khDQ0xOzC/K8=
X-Google-Smtp-Source: AGHT+IFsZsK2mw6jBIY0lJMvI3/T+aTtTJV7pSr8Hw2SWDC9T3wqDKnfiMRj4ewbUZ31aLtZYi2xzaYbm/17MuYJvMuG8Q9+2rRo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1561:b0:3a3:4175:79d2 with SMTP id
 e9e14a558f8ab-3a397cf240bmr12259775ab.14.1728445803106; Tue, 08 Oct 2024
 20:50:03 -0700 (PDT)
Date: Tue, 08 Oct 2024 20:50:03 -0700
In-Reply-To: <4cd7f0c2-a6e8-4bc6-b9fc-4b0edc99f63f@126.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6705fd6b.050a0220.3f80e.0023.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomzhao@126.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com

Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1144f707980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1087e327980000

Note: testing is done by a robot and is best-effort only.
