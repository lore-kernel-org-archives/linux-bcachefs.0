Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 579BB2704
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 13:39:41 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBM5r-0001YG-81; Thu, 07 Dec 2023 21:39:39 +0000
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.15\))
Subject: Re: bcachefs-tools 1.3.5 FTBFS
From: Chris Webb <chris@arachsys.com>
In-Reply-To: <AE9C6F86-E763-4C0B-810D-23311E4816BB@arachsys.com>
Date: Thu, 7 Dec 2023 21:39:37 +0000
Cc: Jan Engelhardt <jengelh@inai.de>,
 Daniel Hill <daniel@gluo.nz>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <77008BC5-68B9-493E-BCB4-BEA7BDFAF08D@arachsys.com>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
 <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
 <20231207081401.w44znpjbndiomrg4@moria.home.lan>
 <3C032AF8-28B9-40D4-81D7-DB53B9432EBA@arachsys.com>
 <AE9C6F86-E763-4C0B-810D-23311E4816BB@arachsys.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Chris Webb <chris@arachsys.com> wrote:

> The current heuristic effectively assumes that we are the dominant  
> memory user at the time, trying to shrink our heap size when it grows  
> over 80% of the physical RAM. That sounds pretty reasonable for a fsck  
> process.

(Although as far as I can see, it is actually the wrong way round:

	/* freeram goes up when system swaps, use malloced data instead */

	want_shrink = -malloc_info.arena + (info.totalram / 10 * 8);
	if (want_shrink <= 0)
		return;

Here, want_shrink is +ve and large when we have allocated nothing at all,  
falling down to zero and the early exit when we've allocated 80%+ of total  
RAM.)

