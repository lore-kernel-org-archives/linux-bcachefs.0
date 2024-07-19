Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57009149C4C
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jul 2024 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405405; cv=none; b=S+UINUXteRXWXwhj8frm3Wo7FZerq9AViREYU+NfDQ6pDUakr25kQoxXG2+WUE1RGTGk+XZqkH0ynUO/hKQvKBrB4cl1wdIVaDmKTw+0xHItPxrITHFdYxNpZi00PpzSzDUYpmhJ5ElIlT/cA2i+nNWbCWb9KKz1wM1icsZd95Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405405; c=relaxed/simple;
	bh=lDeEEMZ0Kpxwhyf4sKV3soVZgWPwvae7hyUqD0wr5PE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MeemPLWoSz+wXaJANgKZ7h0fDf6iDcaVsyJJRIlz1+DdZdAeXm4g4lAgH088X2S6V7YSfJ/1fSTT8APBAYmAq8Q2HrKnu2l2Ns6THn9XGvyXzphXgu6wjnx91qxzs4HGFnCAGSKkxsaxQz1TQkCknEDWLq7tqsc5Ujaeze11++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39884085529so5425735ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jul 2024 09:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405403; x=1722010203;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYTriKvCSORA6mjoEyZ/j31hod0+/l56TzyUyy7BS20=;
        b=Pn9d0zd7SaOwWZIM8xQisYv4Pd0kIV7cNA74S/NNDxXmOEfzEzuyZmMhjVlEmSFZN/
         Kxo43tmDCxspApPYQaPr7Gzl24Nvu35wP1POLypDIXDQnEHedz5OkatFb+ViXTPJhdy5
         mC77uQX69R+yosJSe/KIRSooJGTrkLC7at7r9veO6nl8YufKozlHZkgBpxuC8Ohv4P35
         I0wjJo2hyqtgaiGESywWGUF3fEUDl+GkbuW5S9LLEvhw7BvXRdraMv2Utnu3jSPItc8G
         lSbZbEobmqUvrCykvU1dvU2QnFYHIWzvp8/YehvcbispgOVvUIv3pmM+mrULOZ0JKJZY
         +DxA==
X-Forwarded-Encrypted: i=1; AJvYcCU1TKimL2HyC2SdRQFUltowuQ5VDlwJyFOnCGJ93oyBJFl6uUuEFn3fKrv2cyaUoL0O58vnKW3Ixsl5/pCP+fEWS1n4ZZzurM5MbO0G+i0=
X-Gm-Message-State: AOJu0YzqS3ePXDdayd0o832RvNucOVoUk/mFlZpJa9XbJjtcf4bcHeA+
	jitcpVSiPnBHq3WvfvV0huolDgoMFgTMud06q+aoKuYcETI384w/CHdhLNFbLqSPVVZzuPN3/jp
	PwvyO+Wb4mtRJnJjYz8HVluSqNWDRMDSxV2FTrqS79nYpSzUpjBlQ9Ug=
X-Google-Smtp-Source: AGHT+IF3rcbWSEZyq+y38uvz/jUhjKbV/qZgiis4/0Fdjga073/TguKJYLufFks68w9Ze6uaOVdbTrLSgYtww2YCW/AhXfz9pjBM
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a0d:b0:380:c34a:df56 with SMTP id
 e9e14a558f8ab-398e81c7e16mr98865ab.6.1721405403495; Fri, 19 Jul 2024 09:10:03
 -0700 (PDT)
Date: Fri, 19 Jul 2024 09:10:03 -0700
In-Reply-To: <000000000000e4d9eb061d719657@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097148b061d9bed31@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in bch2_checksum
From: syzbot <syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com>
To: bfoster@redhat.com, cam.alvarez.i@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118fe60d980000
start commit:   0434dbe32053 Merge tag 'linux_kselftest-next-6.11-rc1' of ..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=138fe60d980000
console output: https://syzkaller.appspot.com/x/log.txt?x=158fe60d980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b8bd5292e033239
dashboard link: https://syzkaller.appspot.com/bug?extid=dd3d9835055dacb66f35
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d9ccb5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12633a79980000

Reported-by: syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
