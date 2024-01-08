Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CBA15AE
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id C39C4140DED17;
	Mon,  8 Jan 2024 14:34:43 -0800 (PST)
Date: Mon, 8 Jan 2024 14:34:43 -0800 (PST)
From: "Carl E. Thompson" <cet@carlthompson.net>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Message-ID: <1197499938.727.1704753283643@mail.carlthompson.net>
In-Reply-To: <ZZwV5ohFULB2Q2i9@bfoster>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-2-bfoster@redhat.com>
 <20231219235742.fmon4qqvbabuxq6c@moria.home.lan>
 <ZZagv/f2lWOSMUSn@bfoster>
 <5sttczrkktgkivq5ncusst3rrjqi7hgpx4nswq2vjqn6iqr4b2@25hi2ukb2rh7>
 <ZZwV5ohFULB2Q2i9@bfoster>
Subject: Re: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

I'm not a kernel developer so feel free to ignore this.

> On 2024-01-08 7:33 AM PST Brian Foster <bfoster@redhat.com> wrote:

> ...

> 3. Logistically, this is likely to be a bit awkward for pretty much
> everybody who has a history of working with C code.

I disagree with this point. The ability to declare variables anywhere has been around officially since c99 and unofficially for much longer. For half or more of the 50-year history of C it has been allowed so most people with longtime C experience aren't going to be confused.

In fact C **never** required that **all** variables be declared at the beginning of a function. C has always allowed variables to be declared at the beginning of **any** block including unattached / unconditional blocks which I have personally used to great effect to limit the scope of temporary variables and to declare them close to where they were used going as far back as the 80s.

> In the context of kernel development, something also tells me this has
> potential to be a tinderbox for a flamewar, but who knows.. ;P

Well that may be the **real** issue! From the outside the kernel developers seem reluctant to revisit old decisions... It's 2024 and the mailing lists still don't accept modern email formats (HTML) which seem like they would make discussion easier. I used to be one of those people who resisted the change and preferred text-based email only but it's now been decades. Time to let that one go!

> ...
