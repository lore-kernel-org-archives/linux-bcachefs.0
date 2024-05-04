Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E731AACB
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 May 2024 09:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714816085; cv=none; b=u30LD19CufiFMcosHn2YRG+rZEz8r3mpdNtgIcRMizEw/SP8xubY6fjqx4YjyPjgjxuFXL3e4RsgDNlOGoEjWDc9sfJP0HeR2++oKJpNk127KDExXP0rvj8tkNyoSUze1zWO1LOyrZxy4qCNBaLVqo8MYxwF3BjJ6LIWSX8bS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714816085; c=relaxed/simple;
	bh=mhuJM+GfCQH5IMMrJMXVP9OBz/wYR8fa+oIkbwJ0sFM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=fJjNgJiOUUgWXm6egkD8TTSVq2OWMNafIIGYecUjqyaEJNb/isErowWtqUFM2rph1Iy6yPqK5o7KkOqAUBCbeeMm7Bf6J90uoE7DTw16QTJmEBUNl0C1oe7NVl8fK7PMOFn1YgaX8Mj7dShRdyetu06RX38e6qzWIc4CxRvI7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7da42114485so52221939f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 May 2024 02:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714816084; x=1715420884;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9vMfvjlUyZ95gb2Bl4Phjw9KVzOE/POZUXc/tMc9CNs=;
        b=FFhH2H3Hbx1QgYhK4PIjcq2WDAooM0ZRWIgTpec1tKdKR7m66cbxWwpLlYR+qGAjor
         FV9cmpp2xBxRxQFQWT1cM/TQi2BLqSBtQD+eeOccgACbjfDdelu288MPgVresssyOz+G
         vTShtCjkzRBQug30+uE7S+BoBSZ7f7XIFKhmvWa3tDdbZmDOEsDXHTmmAHpgziu6rmE8
         qi2mmG5MKEmyo9nYFVFTX9qZkWIoayq46SIwrdU6mry516eG0as64DMwj9SKQdXdFL2i
         nGPjQ8MNb5pHsRR6sVBQpkCnUcXALPTqruY/pF/SMPFxB0IcR4OCLyS7+MlGjwmPuSj6
         0a8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnia6F/w/DQ+5b0C1HGOfqfXotANTHNnGkNFmS9XpAsWCC+Njo4sxV2SLCNWv0wIIaNEIBI7oEkvmf/6CxgFe6601tm8N1I+6mmf4C6Vg=
X-Gm-Message-State: AOJu0YxpQuW31/hBDOeAL0TGZhudWqgSD0Xuy3MrKjnwzEawivt95zfU
	602JHw2PC8p2NMkLF6JqGAeSsFOzhlkuYbHRPeLc+oul3H7Z4q7is3Zcz53icQIubpyt2HAPfsD
	B1ifK4X8XzZDmxk3ejQJXWMrpVSiiPM9lr1DlzAFoFBHr5+gDDbn7CMg=
X-Google-Smtp-Source: AGHT+IHQXiciJ6Z11FdD4VBp4JCah2SN9/cx2OFqZQ7b69cg3huTCXgpZXSYi/CyAHP6kwLDQ3n7Nn+vJOJX7J3D0KyvntiXiiQT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a58a:b0:488:59cc:eb41 with SMTP id
 kd10-20020a056638a58a00b0048859cceb41mr36069jab.3.1714816083873; Sat, 04 May
 2024 02:48:03 -0700 (PDT)
Date: Sat, 04 May 2024 02:48:03 -0700
In-Reply-To: <00000000000078baec06178e6601@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088e7bf06179dbbe8@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_trans_srcu_unlock
From: syzbot <syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=147f3908980000
start commit:   f03359bca01b Merge tag 'for-6.9-rc6-tag' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=167f3908980000
console output: https://syzkaller.appspot.com/x/log.txt?x=127f3908980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d42c70980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ce8250980000

Reported-by: syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
