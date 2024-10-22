Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880711CEEA1
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729641244; cv=none; b=BYuJ+KrLRoV5XrxSXC/fPY6xrc0Yojr0M51sVK0IPkTVOdSNe+2eiSlO80srcgcPN3bmKmONZ/uLkqGkJGABmf/Xft05Pma/5lQla4Jv4bn8jEHcZ+FLgxNqS0PvTuWAv2OZg0Dm4JQxyIP6mtxtb+TiE8O3c4B7NRGcw2fgyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729641244; c=relaxed/simple;
	bh=w6dFWm5RFl1qVrcNqTHmJXFLmpmsqtnvNtV3JaUtXW0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bccM0bxw8tJQBAWYTuBZ1312jc7b+liJkNSM8DroEucFRL6dIcY24h/45eHhSgXVM+rPQb/x9SOhukDJoH4lKPm3DDQYD7tj64D+SRfduyeIOvXCY0GkpGSB3id7/eb8QiwCfvunPkct4NrVoVcteOKD5deB9OVnSuQXCbinAY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b7d1e8a0so54098075ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 16:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729641242; x=1730246042;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cxd9axTxFl42+LiBFWYZjB3Ipmm1xW5viZAHR/B3do8=;
        b=qWJy0H6A1vLi6PIX3Vcui43uus60JOjJAKqQxM4woF3QDCEu3Z+36ApsvuLAoOpRi3
         bNhJKrTLbKcpKs/2iYIV/FYpTqYZYyTTa1GNWF8mZSqkN8IboBykO0lWX2/WHLZerxok
         dtUtd7MonQ8gKzizUMVGeUQC7KN5CT/oaFc03NSlLjW9SOPKBWip1EkY08VG3jSFGsi2
         vvhj8EPWUTOWA9fnWp1O4CeZkLufuXm7aF6OM7F0pcFqCvTuLzhpv7xGH+FNdhiscqJn
         Z+B0jGE8qBnEOEf4uCjMr8CNGigMuuEX6VR1A+b08wEZY/Gjynh8ECiMk61mUcGxrLdv
         AjKg==
X-Forwarded-Encrypted: i=1; AJvYcCVsLFZOZZ+LugiDBceN1KAJcPIYJi1RqSXrTgAqG3ck164c+GtUozn4sa5rdI+z3XZDIO0D/V57QTFTU2qU/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXzSJAHGRARZMxqXce2ngDDqFt9O+JOczfDhx2HPP9S7KvIZzB
	zrfIIDrahbtgNja25/adrjB2AQOWsiw6+WsMxf4emUEo5SGac1/AzXNnLONkZ+L5+tJttJJmjnv
	mNznMyTBKXHf7hbXbGSbdMT0VkUK69VxLlg/m1kGRWm4rkEN19zodQsI=
X-Google-Smtp-Source: AGHT+IHJQFW9N63r2wNjck1q/b5wE+bV8tzL/RldOQHzeRI5l/Ri1fsSEe+ypqOp63WDT8SJstMq+IZu1+vfWlsH6xf7m/nMljOg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1feb:b0:3a3:b254:ca2c with SMTP id
 e9e14a558f8ab-3a4d59ff52dmr7700265ab.25.1729641242683; Tue, 22 Oct 2024
 16:54:02 -0700 (PDT)
Date: Tue, 22 Oct 2024 16:54:02 -0700
In-Reply-To: <0000000000004a3a2e061d54e592@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67183b1a.050a0220.1e4b4d.007e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in bch2_opts_apply
From: syzbot <syzbot+c55b814203b2ecab10bb@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, terrelln@fb.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f2d0a7980000
start commit:   5e0497553643 Merge branch 'link_path_walk'
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=283288d3d08ee56f
dashboard link: https://syzkaller.appspot.com/bug?extid=c55b814203b2ecab10bb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bd24b5980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix lockdep splat in bch2_accounting_read

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
