Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01D2A8;
	Mon,  4 Dec 2023 23:06:07 -0800 (PST)
Received: from [192.168.1.123] (ip5b4280bd.dynamic.kabel-deutschland.de [91.66.128.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B33D161E5FE04;
	Tue,  5 Dec 2023 08:05:55 +0100 (CET)
Message-ID: <b1ee97d8-87fb-4430-ae49-4789fa94243c@molgen.mpg.de>
Date: Tue, 5 Dec 2023 08:05:55 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bcachefs] [bug]: missing subvolume 0
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <5cc5076e-3a85-48e2-b75f-a3d1021f531e@molgen.mpg.de>
 <20231205045518.5qje7doafm2fjroa@moria.home.lan>
Content-Language: en-US
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <20231205045518.5qje7doafm2fjroa@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 05:55, Kent Overstreet wrote:
> On Mon, Dec 04, 2023 at 12:03:26PM +0100, Donald Buczek wrote:
>> Reporting to maintainer.pl list, hope that's correct?
>>
>> Probably, this is a trivial one:
>> Linux 6.7.0-rc4.
> 
> now fixed in the bcachefs-for-upstream branch, will be in
> for-next/master shortly

Tested with your bcachefs-for-upstream branch, tip a7b4aa59a076 ("bcachefs: Fix creating snapshot with implict source"). Works for me.

Thanks

   Donald
-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
