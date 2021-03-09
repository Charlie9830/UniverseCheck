--- Universe Check ---
--- V 1.0.0

--- Created by Charlie Hall and Ellie Garnett
--- Last Updated March 9 2021

-- Description: 
-- This Plugin will check whether a universe has been requested ("off-ed" or "on-ed") and if it has been granted (System has enough Parameters) --

------ WARRANTY ---------
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


-- CONFIG VALUES --
local positiveMsgBoxTitle = "Yeah Mate"
local negativeMsgBoxTitle = "Nah Mate"
local notGrantedMsgBoxTitle = "Sorta!"
local uniNumberDialogTitle = "Enter universe number"
local minUniverseNumber = 1
local maxUniverseNumber = 256
-- END CONFIG VALUES --

-- MA Modules --
local textinput = gma.textinput
local msgbox = gma.gui.msgbox
local getPropValue = gma.show.property.get
local getHandle = gma.show.getobj.handle

-- Throw a Dialog asking the user to input a universe number.
function promptForUniNumber()
    return textinput(uniNumberDialogTitle, "")
end

-- Main Function --
function Start()
    -- Ask the User for a Universe number
    local dialogResult = promptForUniNumber()

    -- Nothing to see here
    if dialogResult == "moana" then
        msgbox("Dum Dum", "What can I say except you're welcome!")
        return
    end

    -- Convert user entered string into a Number. Will return nil if string is not a valid number.
    local resultAsNumber = tonumber(dialogResult)

    -- Throw Error Message if user as entered characters other than numbers
    if resultAsNumber == nil then
        msgbox("Error", "Invalid universe number entered")
        return
    end

    -- Floor the result just in case the User entered a Floating point number eg: 1.5
    local sanitizedResult = math.floor(resultAsNumber)

    -- Validate that user entered number is between min and max universe values.
    if sanitizedResult < minUniverseNumber or sanitizedResult > maxUniverseNumber then
        msgbox('Error', "Universe number cannot be less than "..minUniverseNumber.. " or greater than" ..maxUniverseNumber)
        return
    end

    -- Get a Handle to the DmxUniverse console Object
    local uniHandle = getHandle("dmxuniverse " .. sanitizedResult)

    -- Check that we actually got the handle.
    if (uniHandle == nil) then
        msgbox('Error',
            "Couldn't find that Universe, Probably an issue with this Plugin, Developer was drunk or something")
        return
    end

    -- Obtain the values of the Requested and Granted properties.
    local reqValue = getPropValue(uniHandle, "requested")
    local grantedValue = getPropValue(uniHandle, "granted")

    -- Universe has been requested but has not been granted by the console, throw Not Granted Dialog.
    if reqValue == "On" and grantedValue == "No" then
        msgbox(notGrantedMsgBoxTitle,
            "-- KIND OF -- \n\n" .. "Universe " .. sanitizedResult .. " is ON \n" .. "BUT! \n It has not been Granted")
        return
    end

    -- Universe has been requested, throw affirmative dialog.
    if reqValue == "On" then
        msgbox(positiveMsgBoxTitle, "-- YES -- \n\n" .. "Universe " .. sanitizedResult .. " is ON")
        return
    end

    -- Universe has not been Requested. Throw Negative dialog.
    if reqValue == "" then
        msgbox(negativeMsgBoxTitle, "-- NO -- \n\n" .. "Universe " .. sanitizedResult .. " is OFF")
        return
    end

    return
end


-- Return a reference to your 'main' function so that MA knows which function to use as the entry point.
return Start
