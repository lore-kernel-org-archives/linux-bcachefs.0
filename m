X-Greylist: delayed 1015 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Dec 2023 00:10:27 PST
Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68424B2
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 00:10:27 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rB9CM-0000FZ-Iv; Thu, 07 Dec 2023 07:53:30 +0000
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
In-Reply-To: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
Date: Thu, 7 Dec 2023 07:53:29 +0000
Cc: Daniel Hill <daniel@gluo.nz>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
To: Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Jan Engelhardt <jengelh@inai.de> wrote:

>
> With glibc 2.31, bcachefs-tools 314ce7d (tag: v1.3.5) cannot be built:
>
> [   30s] linux/shrinker.c: In function 'run_shrinkers':
> [   30s] linux/shrinker.c:72:9: error: variable 'malloc_info' has  
> initializer but incomplete type
> [   30s]   struct mallinfo2 malloc_info = mallinfo2();
> [   30s]          ^~~~~~~~~
>
> This is a glibc-2.34 specific feature.

It's glibc-specific too, so it'll break building the tools on on musl  
distributions like alpine and void.

I don't remember compatibility problems with musl when I last built and  
tested a few months ago, so probably a relatively recent and localised  
regression?

Best wishes,

Chris.
