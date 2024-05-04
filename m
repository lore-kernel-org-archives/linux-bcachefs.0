Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36798800
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 May 2024 00:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714782547; cv=none; b=uaoiWUbHiWZtU60X0Snz+V7lmSInc2gOyWPmxOvg0H+gfjHCCwjR4bwSWqGhx8VwNtbAjGUf6uQcuUITA9xIe281RA1ChlZsldKt8tDmDPa7xgMB3XlBSUDR/NyrAe6dZ7lj8F5Zihy3AVGhaJ7+ORlaXuTdfb/sn6GjzBH5gRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714782547; c=relaxed/simple;
	bh=PSu/U2rEr9Crn+mdTayQQje4O/D+NQcQSkn5x554Ggg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qdzcljKZKPjXqAeA7DXioG1ktPpK/5HGZOHkH5zxq/z9yZPiIp8zkrNBZhXCCQdQzKNwwvErpN3WCTPvZ7OuHtW7IiHTmE3xYj+09U9dMQmojOV5kB6vsYXXC1lJBLwoCJdedX5OqAMgn1AZyPhPPKDHVymsUl6zoqWOdPAZJnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7dec4e29827so21382739f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 May 2024 17:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714782545; x=1715387345;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=asD/7hCmqzKw0GIMHRL0JAdUwek+LTvD3ZFoISBMKCU=;
        b=nSJ85HLFop+GB7afPylqQUsuNVye5lxFzLDv9AtUAKbUdr7luvs3xpAg7v6rQ+FqOt
         FATxKpc0HEMzGhZibriI0dzKSmnFXXP9NaZV/Lkb3P9U/YQWVXGnGesttCRxxMDE677n
         od3JKnXtaXm6voJp6iFRApfLeiCU6HOf597f2fZcmpVRVTcSAURsYSSK2u7dxZDvNmoc
         2wTuZYaQV4IH+ynASFd9tbcKwHpfu+xJgjbEnSnTy7JOO9Y8a3058OdAV+pR5l4/Uvs4
         UWi7jS0F/ce+JKaiS0KD76fWB2x3NRBQzyeE2/gXQiDgeK7wm0RHHzRcpoq1TuHcAAc/
         f0ww==
X-Forwarded-Encrypted: i=1; AJvYcCV8gHEGQ4pJ6bY4Su2Athesc+DlBOECrJHf00oCM+N2ctZFYNDOkK9vv/Iku+B1+Upcxeek/tvkZEgmBsay7a+htZW6xMXYBacY12ezswI=
X-Gm-Message-State: AOJu0YyiubFyC3NZu6E+7NBI5VMlGvJKnOwlxE6Kl8L2EPw7n7nbmu8b
	t3B1/PXTbG7pl6//8xAOsr+wzzglOKmMGGfzKekbtUVAoD9QcIeIBQ6yEBVFVDXedpiMPMLxvzE
	+is1v4pcYZjZs8yVkVOfoRZjH2Dwky/QJ1Ma6GE/ZGFFlaroCF8pEgA0=
X-Google-Smtp-Source: AGHT+IFUwj5spljY2Iwert/KmKUdCcRSfzV4oog2DeoNjyjIG8PlI/59PayICbggpDfu1obeBgkmG1QeiTxDIT2A1jG9EXs9UE/1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8c18:b0:487:5aca:1a49 with SMTP id
 jl24-20020a0566388c1800b004875aca1a49mr139772jab.1.1714782545529; Fri, 03 May
 2024 17:29:05 -0700 (PDT)
Date: Fri, 03 May 2024 17:29:05 -0700
In-Reply-To: <000000000000367c770617901bba@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e6133061795ec44@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in __closure_sync
From: syzbot <syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15745bc4980000
start commit:   f03359bca01b Merge tag 'for-6.9-rc6-tag' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17745bc4980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13745bc4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a7c31f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16109450980000

Reported-by: syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
