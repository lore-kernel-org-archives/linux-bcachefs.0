Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE228B514
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754328367; cv=none; b=MVzmdIgptFSntkcG08YQQgoJeL9nEpc0vbHZpf9e3lU0PNrWPUa75CXcVZjLzB9GTtCMsa+XPbmLBRMlxLcat2/AcZOWjKUgHU2yCEcufeloajEsooWokYC0S5QoBXklDVvjEHJ/prmEJbE4SX3c/MwB608xMKOvDkoxsdv8FIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754328367; c=relaxed/simple;
	bh=Qezuv9NuVZOhWaySQtgzOxHiO1L4SfJn5ghYTPVBw1s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qKghOoaHCb81gp3LmhI3PKAHNBsO0efdihIyL1oDeonK6WoJjEvv8vupZ27Pz7yjxOf2o5gpLgh3q1q2oHTvVjoZCfS2KHJri9jiHq0R8NyP1wnI7mJSXWiuMEmJs8ZcDY2a7W0hZGl298Xebn+uTbXwIO5F/JFFhOJyuIkKsts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8818b1512c2so81769639f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 10:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754328365; x=1754933165;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGNXSO7IuhXm4UYEUpJyIzcI75ucxzQehTEB7opvPpw=;
        b=fUmX3AfVZngG5kIeOeOdWKoJmNdaSj+Ht3ML2M4B/EEhobW5ZQY/sMKh3PsCzEHFOx
         IGP5mZzSDHO9e/ra0h2d0244vA6D9iGFaN2w1Rl+/KpShjO1UynO2/vo+8YZDvBvwcVK
         vB37SHpDZgahEUk/5vEEb3lVkR7Ny0gennzniZWbFPS3lYA+RHdLoSuUOLSn3YuLBaJZ
         ZwaZSe4eiFq1PmNxHopRZZZNRN3v/REU/JhSCwGD1v6xEMmLfZ5/DkUWxf41VIYFtZBo
         q6koZKd8b/3CW7BEWgrcD1fntD0rrB52MeRPe0WxwUmrm9m6SJwCqAKWalKkg770+sQq
         1dkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWcSSgTQTigD3CfN5TtKasG5a2mRzLMGssZRDmViq1aiH5AKGx+QPmHgqyegm6sSQROvB7OX8D77+gxW/L3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeAlqf4w73NROiOwKFLlUcR6rOwLa70gPttScueLJHdYYic4RS
	ZnRE7q+ZSghctWjQx4pqp8EK20GwGO7MVWW3dAFm+Ig884HGwNITRp8MqCyG4tM8/CoUioTsbpr
	7eQVgdiEtRqM4wQg2JTOFHGBI/W8QYR8ERIlOzBR1tTCYi1e9RCbazHlAYr0=
X-Google-Smtp-Source: AGHT+IHWWgSdVCva3mVOA0w0tIxfsrZTdnaw0rPAlY9oMSyW/c4V4pnoepcwuBQ4hg/IMmjMvGyhsI5JTGGAPIiHPM5SIYrUpnqT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:85d1:0:b0:864:68b0:60b3 with SMTP id
 ca18e2360f4ac-881683d6ba6mr1589110039f.12.1754328364766; Mon, 04 Aug 2025
 10:26:04 -0700 (PDT)
Date: Mon, 04 Aug 2025 10:26:04 -0700
In-Reply-To: <68905ecc.050a0220.7f033.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6890ed2c.050a0220.1fc43d.0010.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_accounting_validate
From: syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com>
To: bfoster@redhat.com, elver@google.com, justinstitt@google.com, 
	keescook@chromium.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 557f8c582a9ba8abe6aa0fd734b6f342af106b26
Author: Kees Cook <keescook@chromium.org>
Date:   Thu Jan 18 23:06:05 2024 +0000

    ubsan: Reintroduce signed overflow sanitizer

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161982f0580000
start commit:   352af6a011d5 Merge tag 'rust-6.17' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=151982f0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=111982f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cae1291240e8962a
dashboard link: https://syzkaller.appspot.com/bug?extid=cd063f869beedf5b9cd7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dcc6a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133e02f0580000

Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Fixes: 557f8c582a9b ("ubsan: Reintroduce signed overflow sanitizer")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
