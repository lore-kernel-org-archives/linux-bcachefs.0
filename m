Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A2C17DE36
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Jan 2025 04:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520805; cv=none; b=IlOwgFqKW7vwFXjfeXqdMS9cf5oIN6t90ifWl/UT/dHvoVaMXP2GMJY0VDDD7LdErnt0lsH1evJnx7Tz9zXPt2/IcbABCLpHaAhD6EiGSvkh7/fzNFgPDsagGu6d2wtB+XCbeFGCdd/pO74vvZnDbaxyT82qAaT/AUhZNw6SHWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520805; c=relaxed/simple;
	bh=dg9VamvAbwHHKNgWr8MaQdwDRlbk8Hv4dDqWvseGQtc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=OdPpQxlmYvRT5FhtNvE7PsfpmVW88u1/QrVLXbUFlN2O5tBhJs2vmZ/zrgy72MUTvBAi2TmwrEW9SBI2gVRWNSQS521m5IvLj5IqptxbtRdtEjHMJ5Wo2k6q+V/FVPK2p+KW7yVovEfDicTgX+dO6OlYiIkjt6LXQhM8WxXg1sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so44716845ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Jan 2025 20:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737520802; x=1738125602;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xaO6Cz+oF6AjPCOe8eXNGAraGaqpP80svKFDFKKVtR0=;
        b=njBq86IY38EHeH8gv3YYyG0JDpTNM6DqhbQSvZqTOKroI/vz+hqwI1vL078J/Qqi+R
         4ulmIdmqXrz0AB1L6wGvAFOHJIPGu+5FbVWpuOw1/Rim4g5IQLuVtVmnQ+ZG84cvyLJB
         Xz9Uun9MBB7I1jL9pQjQ6xojrkxQZwxcE1o65epxO4P3LSaDoPxAjj+2/wXMhb9mBiI4
         DGZN63xJ0C4TfG1vNExNhRMgW21+pYZjBG1taS68a/t5yoh+WH7F9hn+yMvDKz29caJB
         UngrCvbwDdkhe9xLI34etLCJWicyML06Eha9Yege+1e8r7x3eU0FIiRaHB8ec0R2f2De
         q0bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbQhFOSNjiT/lp9nxztpRQnf+mejWwAog+lbpnXyNcdfCKesvKH/8JmBWExwstZK6vmHnn0L9Is1F4dfkwRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhd8YwsklcCKk7nQzV3/5lNDf1HAlLzGcMIDVpRt8Qf/baUs7a
	rEn/PasdumhqhV/hbu0YNtCAKnWSNI//lyOZnMxtdXSR5U7pWBd+SzifNzHinIorBQa0ACK+BWH
	/zcMglZK6LsY3HeFTGHvdmgSkx6yCvuUq4up41dzMkRBRrWuqlD4gneQ=
X-Google-Smtp-Source: AGHT+IHuSxpEXCzT78/8A2dXvtK8mXYcPddmTs37KsN8p0DwPdvvC4Kv18veazWQqG82uu3/kJQtNNgSc4tdt+5qBQZLEa5KFLSr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4b:b0:3ce:8d8b:204e with SMTP id
 e9e14a558f8ab-3cf7440a292mr149544035ab.7.1737520802578; Tue, 21 Jan 2025
 20:40:02 -0800 (PST)
Date: Tue, 21 Jan 2025 20:40:02 -0800
In-Reply-To: <66f09be2.050a0220.a27de.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679076a2.050a0220.15cac.0178.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_iter_verify_entry_exit
 (2)
From: syzbot <syzbot+dc1f3e7147b8fc81e0ac@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ef8ab0580000
start commit:   b9d8a295ed6b Merge tag 'x86_misc_for_v6.14_rc1' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13ef8ab0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15ef8ab0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b34d979b03d5656f
dashboard link: https://syzkaller.appspot.com/bug?extid=dc1f3e7147b8fc81e0ac
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1062e824580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fb89f8580000

Reported-by: syzbot+dc1f3e7147b8fc81e0ac@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
